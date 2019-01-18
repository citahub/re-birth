# frozen_string_literal: true

module CitaSync
  class Persist
    class SystemTimeoutError < StandardError
    end
    class NotReadyError < StandardError
    end

    class << self
      # get save blocks or not config
      #
      # @return [true, false] return save blocks or not from config.
      def save_blocks?
        ENV["SAVE_BLOCKS"] != "false"
      end

      # save a block with set transaction true
      #
      # @param hex_num_str [String] block number in hex_num_str
      # @return [Block, SyncError] return SyncError if rpc return an error
      def save_block(hex_num_str)
        rpc_params = [hex_num_str, true]
        data = CitaSync::Api.get_block_by_number(*rpc_params)
        result = data["result"]
        error = data["error"]

        # handle error
        return handle_error("getBlockByNumber", rpc_params, error) unless error.nil?

        # handle for result.nil
        # raise "network error, retry later" if result.nil?
        # error is nil now, if result is also nil, means result is nil (like after snapshot)
        return if result.nil?

        block_header = result["header"]
        block_number_hex_str = block_header["number"]
        block_number = HexUtils.to_decimal(block_number_hex_str)
        block_hash = result["hash"]
        transactions_data = result.dig("body", "transactions")
        timestamp = block_header["timestamp"]
        block = Block.new(
          version: result["version"],
          block_hash: block_hash,
          header: result["header"],
          # body: result["body"],
          block_number: block_number,
          transaction_count: transactions_data.count,
          timestamp: timestamp,
          proposer: block_header["proposer"],
          quota_used: (block_header["quotaUsed"] || block_header["gasUsed"]).hex
        )
        block.save! if save_blocks?

        transaction_params = transactions_data.map.with_index { |tx_data, index| [tx_data, index, block_number, block_hash, timestamp] }
        SaveTransactionWorker.push_bulk(transaction_params) { |param| param }

        block
      end

      # save a transaction
      # block persisted first
      #
      # @param tx_data [Hash] hash and content of transaction
      # @param index [Integer] transaction index
      # @param block_number [Integer]
      # @param block_hash [String]
      # @return [Transaction, SyncError] return SyncError if rpc return an error
      def save_transaction(tx_data, index, block_number, block_hash, timestamp)
        hash = tx_data["hash"]
        content = tx_data["content"]
        receipt_data = CitaSync::Api.get_transaction_receipt(hash)

        receipt_result = receipt_data["result"]
        receipt_error = receipt_data["error"]

        # handle error
        return handle_error("getTransactionReceipt", [hash], receipt_error) unless receipt_error.nil?

        return if tx_data.nil? && receipt_result.nil?

        message = Message.new(content)
        transaction = Transaction.new(
          tx_hash: hash,
          content: content,
          block_number: block_number,
          block_hash: block_hash,
          index: index,
          from: message.from,
          to: message.to,
          data: message.data,
          value: HexUtils.to_decimal(message.value),
          version: message.version,
          chain_id: message.chain_id,
          contract_address: receipt_result["contractAddress"],
          quota_used: HexUtils.to_decimal(receipt_result["quotaUsed"] || receipt_result["gasUsed"]),
          error_message: receipt_result["errorMessage"],
          timestamp: timestamp
        )

        ApplicationRecord.transaction do
          transaction.save!
          receipt_result["logs"]&.each do |log|
            EventLog.create!(
              log.transform_keys { |key| key.to_s.underscore }
                .merge(
                  "block_number" => HexUtils.to_decimal(log["blockNumber"]),
                  "transaction_index" => HexUtils.to_decimal(log["transactionIndex"]),
                  "log_index" => HexUtils.to_decimal(log["logIndex"]),
                  "transaction_log_index" => HexUtils.to_decimal(log["transactionLogIndex"])
                )
            )
          end
        end

        event_log_pkeys = transaction.event_logs.map { |el| [el.transaction_hash, el.transaction_log_index] }
        SaveErc20TransferWorker.push_bulk(event_log_pkeys) { |pkey| pkey }

        transaction
      end

      # save event logs
      #
      # @param logs [Array] event logs
      # @return [[EventLog]]
      def save_event_logs(logs)
        return if logs.blank?

        attrs = logs.map do |log|
          log.transform_keys { |key| key.to_s.underscore }
             .merge(
               "block_number" => HexUtils.to_decimal(log["blockNumber"]),
               "transaction_index" => HexUtils.to_decimal(log["transactionIndex"]),
               "log_index" => HexUtils.to_decimal(log["logIndex"]),
               "transaction_log_index" => HexUtils.to_decimal(log["transactionLogIndex"])
             )
        end

        event_logs = EventLog.create!(attrs)
        # if event log is a registered ERC20 contract address, process it
        event_log_pkeys = event_logs.map { |el| [el.transaction_hash, el.transaction_log_index] }
        SaveErc20TransferWorker.push_bulk(event_log_pkeys) { |pkey| pkey }
        event_logs
      end

      # save blocks and there's transactions and meta data, from next db block to last block in chain
      #
      # @return [void]
      def save_blocks_with_infos
        block_number_hex_str = CitaSync::Api.block_number["result"]
        block_number = HexUtils.to_decimal(block_number_hex_str)

        return if block_number.nil?

        event_loop_queue = Sidekiq::Queue.new("event_loop")
        default_queue = Sidekiq::Queue.new("default")

        # current biggest block number in database
        last_block_number = SyncInfo.current_block_number || -1
        ((last_block_number + 1)..block_number).each do |num|
          break if !Rails.env.test? && (event_loop_queue.size >= 100 || default_queue.size >= 500)

          hex_str = HexUtils.to_hex(num)
          SaveBlockWorker.perform_async(hex_str)
          SyncInfo.current_block_number = num
        end
      end

      # start a loop to poll chain, for realtime sync block infos
      #
      # @return [void]
      def realtime_sync
        loop do
          save_blocks_with_infos
        end
        sleep(ENV["LOOP_INTERVAL"].to_f)
      end

      private

      def handle_error(method, params, error)
        return if error.blank?

        code = error["code"]
        message = error["message"]

        raise SystemTimeoutError, message if code == -32_099
        raise NotReadyError, message if code == -32_603

        SyncError.create(
          method: method,
          params: params,
          code: code,
          message: message
        )
      end
    end
  end
end
