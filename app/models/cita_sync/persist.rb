module CitaSync
  class Persist

    class << self
      # save a block
      def save_block(hex_num_str)
        data = CitaSync::Api.get_block_by_number(hex_num_str, true)
        result = data["result"]
        return if result.nil?
        block_number_hex_str = result.dig("header", "number")
        block_number = Basic.hex_str_to_number(block_number_hex_str)
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
      def save_transaction(hash, block = nil)
        data = CitaSync::Api.get_transaction(hash)
        result = data["result"]
        return if result.nil?
        block ||= Block.find_by_block_number(CitaSync::Basic.hex_str_to_number(result["blockNumber"]))
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
      def save_meta_data(block_number, block = nil)
        data = CitaSync::Api.get_meta_data(block_number)
        result = data["result"]
        return if result.nil?
        # block number in decimal system
        block_number_decimal = CitaSync::Basic.hex_str_to_number(block_number)
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

      # save balance
      # block_number is hex number string
      def save_balance(addr, block_number)
        addr_downcase = addr.downcase
        # height number in decimal system
        data = CitaSync::Api.get_balance(addr_downcase, block_number)
        return [nil, data] unless block_number.start_with?("0x")
        value = data["result"]
        balance = Balance.create(
          address: addr_downcase,
          block_number: CitaSync::Basic.hex_str_to_number(block_number),
          value: value
        )
        [balance, data]
      end

      # save abi
      # block_number is hex number string
      def save_abi(addr, block_number)
        addr_downcase = addr.downcase
        # block_number in decimal system
        data = CitaSync::Api.get_abi(addr_downcase, block_number)
        return [nil, data] unless block_number.start_with?("0x")
        value = data["result"]
        abi = Abi.create(
          address: addr_downcase,
          block_number: CitaSync::Basic.hex_str_to_number(block_number),
          value: value
        )
        [abi, data]
      end

      # save one block with it's transactions and meta data
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
      def save_blocks_with_infos
        block_number_hex_str = CitaSync::Api.block_number["result"]
        block_number = CitaSync::Basic.hex_str_to_number(block_number_hex_str)

        # current biggest block number in database
        last_block = ::Block.order(block_number: :desc).first
        last_block_number = last_block&.block_number || -1
        ((last_block_number + 1)..block_number).each do |num|
          hex_str = CitaSync::Basic.number_to_hex_str(num)
          save_block_with_infos(hex_str)
        end
      end

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
