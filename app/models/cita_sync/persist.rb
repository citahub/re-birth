# frozen_string_literal: true

module CitaSync
  class Persist
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
        data = CitaSync::Api.get_block_by_number(hex_num_str, true)
        result = data["result"]
        error = data["error"]

        # handle error
        return handle_error("getBlockByNumber", [hex_num_str, true], error) unless error.nil?

        # handle for result.nil
        return nil if result.nil?

        block_number_hex_str = result.dig("header", "number")
        block_number = HexUtils.to_decimal(block_number_hex_str)
        block = Block.new(
          version: result["version"],
          cita_hash: result["hash"],
          header: result["header"],
          body: result["body"],
          block_number: block_number,
          transaction_count: result.dig("body", "transactions").count
        )
        block.save if save_blocks?
        block
      end

      # save a transaction
      # block persisted first
      #
      # @param hash [String] hash of transaction
      # @return [Transaction, SyncError] return SyncError if rpc return an error
      def save_transaction(hash)
        data = CitaSync::Api.get_transaction(hash)
        result = data["result"]
        error = data["error"]

        # handle error
        return handle_error("getTransaction", [hash], error) unless error.nil?
        return nil if result.nil?

        block = if save_blocks?
                  Block.find_by(block_number: HexUtils.to_decimal(result["blockNumber"]))
                end
        content = result["content"]
        message = Message.new(content)
        transaction = Transaction.new(
          cita_hash: result["hash"],
          content: content,
          block_number: result["blockNumber"],
          block_hash: result["blockHash"],
          index: result["index"],
          block: block,
          from: message.from,
          to: message.to,
          data: message.data,
          value: message.value
        )
        receipt_data = CitaSync::Api.get_transaction_receipt(hash)
        receipt_result = receipt_data["result"]
        unless receipt_result.nil?
          transaction.contract_address = receipt_result["contractAddress"]
          transaction.gas_used = receipt_result["gasUsed"]
        end
        transaction.save
        save_event_logs(receipt_result["logs"]) unless receipt_result.nil?
        transaction
      end

      # save event logs
      #
      # @param logs [Array] event logs
      # @return [[EventLog]]
      def save_event_logs(logs)
        return if logs.blank?

        attrs = logs.map do |log|
          tx = Transaction.find_by(cita_hash: log["transactionHash"])
          block = save_blocks? ? Block.find_by(cita_hash: log["blockHash"]) : nil
          log.transform_keys { |key| key.to_s.underscore }.merge(tx: tx, block: block)
        end

        event_logs = EventLog.create(attrs)
        # if event log is a registered ERC20 contract address, process it
        event_logs.each do |el|
          if Erc20Transfer.exists?(el.address&.downcase) && Erc20Transfer.transfer?(el.topics)
            Erc20Transfer.save_from_event_log(el)
          end
        end
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

      # save one block with it's transactions and meta data
      #
      # @param block_number_hex_str [String] hex string with "0x" prefix
      # @return [void]
      def save_block_with_infos(block_number_hex_str)
        # merge to one commit, can be faster
        ApplicationRecord.transaction do
          block = save_block(block_number_hex_str)
          return if block.nil?

          hashes = block.transactions.map { |t| t&.with_indifferent_access&.dig :hash }
          hashes.each do |hash|
            save_transaction(hash)
          end
        end
      end

      # save blocks and there's transactions and meta data, from next db block to last block in chain
      #
      # @return [void]
      def save_blocks_with_infos
        block_number_hex_str = CitaSync::Api.block_number["result"]
        block_number = HexUtils.to_decimal(block_number_hex_str)

        # current biggest block number in database
        last_block_number = SyncInfo.current_block_number || -1
        ((last_block_number + 1)..block_number).each do |num|
          hex_str = HexUtils.to_hex(num)
          ApplicationRecord.transaction do
            save_block_with_infos(hex_str)
            SyncInfo.current_block_number = num
          end
        end
      end

      # start a loop to poll chain, for realtime sync block infos
      #
      # @return [void]
      def realtime_sync
        loop do
          save_blocks_with_infos
        rescue StandardError
        end
      end

      private

      def handle_error(method, params, error)
        return if error.blank?

        code = error["code"]
        message = error["message"]

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
