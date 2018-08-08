module CitaSync
  class Persist

    class << self
      # save a block with set transaction true
      #
      # @param hex_num_str [String] block number in hex_num_str
      # @return [Block, SyncError] return SyncError if rpc return an error
      def save_block(hex_num_str)
        data = CitaSync::Api.get_block_by_number(hex_num_str, true)
        result = data["result"]

        # handle error
        return handle_error("getBlockByNumber", [hex_num_str, true], data) if result.nil?

        block_number_hex_str = result.dig("header", "number")
        block_number = HexUtils.to_decimal(block_number_hex_str)
        Block.create(
          version: result["version"],
          cita_hash: result["hash"],
          header: result["header"],
          body: result["body"],
          block_number: block_number,
          transaction_count: result.dig("body", "transactions").count
        )
      end

      # save a transaction
      # block persisted first
      #
      # @param hash [String] hash of transaction
      # @param block [Block, nil] the block that transaction belongs to, nil means find in db.
      # @return [Transaction, SyncError] return SyncError if rpc return an error
      def save_transaction(hash, block = nil)
        data = CitaSync::Api.get_transaction(hash)
        result = data["result"]

        # handle error
        return handle_error("getTransaction", [hash], data) if result.nil?

        block ||= Block.find_by_block_number(HexUtils.to_decimal(result["blockNumber"]))
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
        transaction
      end

      # save a meta data
      # block_number is a hex string
      #
      # @param block_number [String] hex string
      # @param block [Block, nil] the block that transaction belongs to, nil means find in db.
      # @return [MetaData, SyncError] return SyncError if rpc return an error
      def save_meta_data(block_number, block = nil)
        data = CitaSync::Api.get_meta_data(block_number)
        result = data["result"]

        # handle error
        return handle_error("getMetaData", [block_number], data) if result.nil?

        # block number in decimal system
        block_number_decimal = HexUtils.to_decimal(block_number)
        block ||= Block.find_by_block_number(block_number_decimal)
        MetaData.create(
          chain_id: result["chainId"],
          chain_name: result["chainName"],
          operator: result["operator"],
          genesis_timestamp: result["genesisTimestamp"],
          validators: result["validators"],
          block_interval: result["blockInterval"],
          token_symbol: result["tokenSymbol"],
          token_avatar: result["tokenAvatar"],
          website: result["website"],
          block_number: block_number_decimal,
          block: block
        )
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

        # handle error
        return [handle_error("getBalance", [addr_downcase, block_number], data), data] unless data["error"].nil?

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

        # handle error
        return [handle_error("getAbi", [addr_downcase, block_number], data), data] unless data["error"].nil?

        return [nil, data] unless block_number.start_with?("0x")
        value = data["result"]
        abi = Abi.create(
          address: addr_downcase,
          block_number: HexUtils.to_decimal(block_number),
          value: value
        )
        [abi, data]
      end

      private def handle_error(method, params, data)
        error = data["error"]
        return if error.nil?
        code = error["code"]
        message = error["message"]

        SyncError.create(
          method: method,
          params: params,
          code: code,
          message: message
        )
      end

      # save one block with it's transactions and meta data
      #
      # @param block_number_hex_str [String] hex string with "0x" prefix
      # @return [void]
      def save_block_with_infos(block_number_hex_str)
        # merge to one commit, can be faster
        ApplicationRecord.transaction do
          block = save_block(block_number_hex_str)
          _meta_data = save_meta_data(block_number_hex_str, block)
          hashes = block.transactions.map { |t| t&.with_indifferent_access[:hash] }
          hashes.each do |hash|
            save_transaction(hash, block)
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
        last_block = ::Block.order(block_number: :desc).first
        last_block_number = last_block&.block_number || -1
        ((last_block_number + 1)..block_number).each do |num|
          hex_str = HexUtils.to_hex(num)
          save_block_with_infos(hex_str)
        end
      end

      # start a loop to poll chain, for realtime sync block infos
      #
      # @return [void]
      def realtime_sync
        loop do
          begin
            save_blocks_with_infos
          rescue
          end
        end
      end

    end

  end
end
