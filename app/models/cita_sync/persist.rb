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

        block_number_hex_str = result.dig("header", "number")
        block_number = HexUtils.to_decimal(block_number_hex_str)
        block_hash = result["hash"]
        transactions_data = result.dig("body", "transactions")
        block = Block.new(
          version: result["version"],
          cita_hash: block_hash,
          header: result["header"],
          # body: result["body"],
          block_number: block_number,
          transaction_count: transactions_data.count
        )
        block.save! if save_blocks?

        transaction_params = transactions_data.map.with_index { |tx_data, index| [tx_data, index, block_number_hex_str, block_hash] }
        SaveTransactionWorker.push_bulk(transaction_params) { |param| param }

        block
      end

      # save a transaction
      # block persisted first
      #
      # @param tx_data [Hash] hash and content of transaction
      # @param index [Integer] transaction index
      # @return [Transaction, SyncError] return SyncError if rpc return an error
      def save_transaction(tx_data, index, block_number_hex_str, block_hash)
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
          cita_hash: hash,
          content: content,
          block_number: block_number_hex_str,
          block_hash: block_hash,
          index: HexUtils.to_hex(index),
          from: message.from,
          to: message.to,
          data: message.data,
          value: message.value,
          version: message.version,
          chain_id: message.chain_id,
          contract_address: receipt_result["contractAddress"],
          quota_used: receipt_result["quotaUsed"] || receipt_result["gasUsed"],
          error_message: receipt_result["errorMessage"]
        )

        ApplicationRecord.transaction do
          transaction.save!
          receipt_result["logs"]&.each do |log|
            transaction.event_logs.build(
              log.transform_keys { |key| key.to_s.underscore }
                .merge(
                  "transaction_index" => HexUtils.to_decimal(log["transactionIndex"]),
                  "log_index" => HexUtils.to_decimal(log["logIndex"]),
                  "transaction_log_index" => HexUtils.to_decimal(log["transactionLogIndex"])
                )
            )
          end
          transaction.save!
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
              "transaction_index" => HexUtils.to_decimal(log["transactionIndex"]),
              "log_index" => HexUtils.to_decimal(log["logIndex"]),
              "transaction_log_index" => HexUtils.to_decimal(log["transactionLogIndex"])
            )
        end

        event_logs = EventLog.create!(attrs)
        # if event log is a registered ERC20 contract address, process it
        event_log_pkeys = event_logs.map { |el| [el.transaction_hash, el.transaction_log_index] }
        SaveErc20TransferWorker.push_bulk(event_log_pkeys) { |pkey| pkey }
      end

      # save balance, get balance and http response body
      #
      # @param addr [String] addr hex string
      # @param block_number [String] hex string with "0x" prefix
      # @return [[Balance, Hash], [SyncError, Hash]] return SyncError if rpc return an error
      def save_balance(addr, block_number)
        addr_downcase = addr.downcase
        # height number in decimal system
        data = CitaSync::Api.get_balance(addr_downcase, block_number)
        error = data["error"]

        # handle error
        return [handle_error("getBalance", [addr_downcase, block_number], error), data] unless error.nil?

        return [nil, data] unless block_number.start_with?("0x")

        value = data["result"]
        balance = Balance.create(
          address: addr_downcase,
          block_number: HexUtils.to_decimal(block_number),
          value: value
        )
        [balance, data]
      end

      # save abi
      #
      # @param addr [String] addr hex string
      # @param block_number [String] hex string with "0x" prefix
      # @return [[Abi, Hash], [SyncError, Hash]] return SyncError if rpc return an error
      def save_abi(addr, block_number)
        addr_downcase = addr.downcase
        # block_number in decimal system
        data = CitaSync::Api.get_abi(addr_downcase, block_number)
        error = data["error"]

        # handle error
        return [handle_error("getAbi", [addr_downcase, block_number], error), data] unless error.nil?

        return [nil, data] unless block_number.start_with?("0x")

        value = data["result"]
        abi = Abi.create(
          address: addr_downcase,
          block_number: HexUtils.to_decimal(block_number),
          value: value
        )
        [abi, data]
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
      end

      private

      def handle_error(method, params, error)
        return if error.blank?

        code = error["code"]
        message = error["message"]

        raise SystemTimeoutError, message if code == -32099
        raise NotReadyError, message if code == -32603

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
