module CitaSync
  class Persist

    class << self
      # save a block
      def save_block(hex_num_str, transaction = true)
        data = CitaSync::Api.get_block_by_number(hex_num_str, transaction)
        result = data["result"]
        return if result.nil?
        block_number_hex_str = result.dig("header", "number")
        block_number = Basic.hex_str_to_number(block_number_hex_str)
        Block.create(
          version: result["version"],
          cita_hash: result["hash"],
          header: result["header"],
          body: result["body"],
          block_number: block_number
        )
      end

      # save a transaction
      # block persisted first
      def save_transaction(hash, block = nil)
        data = CitaSync::Api.get_transaction(hash)
        result = data["result"]
        return if result.nil?
        block ||= Block.find_by_block_number(CitaSync::Basic.hex_str_to_number(result["blockNumber"]))
        Transaction.create(
          cita_hash: result["hash"],
          content: result["content"],
          block_number: result["blockNumber"],
          block_hash: result["blockHash"],
          index: result["index"],
          block: block
        )
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
      # height is hex number string
      def save_balance(addr, height)
        return unless height.start_with?("0x")
        # height number in decimal system
        data = CitaSync::Api.get_balance(addr, height)
        value = data["result"]
        Balance.create(
          address: addr,
          height: CitaSync::Basic.hex_str_to_number(height),
          value: value
        )
      end

      # save abi
      # block_number is hex number string
      def save_abi(addr, block_number)
        return unless block_number.start_with?("0x")
        # block_number in decimal system
        data = CitaSync::Api.get_abi(addr, block_number)
        value = data["result"]
        Abi.create(
          address: addr,
          block_number: CitaSync::Basic.hex_str_to_number(block_number),
          value: value
        )
      end

      # save one block with it's transactions and meta data
      def save_block_with_infos(block_number_hex_str)
        block = save_block(block_number_hex_str)
        _meta_data = save_meta_data(block_number_hex_str, block)
        hashes = block.transactions.map { |t| t&.with_indifferent_access[:hash] }
        hashes.each do |hash|
          save_transaction(hash, block)
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

    end

  end
end
