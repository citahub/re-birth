module CitaSync
  class Persist

    class << self
      # save a block
      def save_block(hex_num_str, transaction = true)
        data = CitaSync::Api.cita_get_block_by_number(hex_num_str, transaction)
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
        data = CitaSync::Api.cita_get_transaction(hash)
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

      # save one block with it's transaction
      def save_block_with_transactions(block_number_hex_str)
        block = save_block(block_number_hex_str)
        hashes = block.transactions.map { |t| t&.with_indifferent_access[:hash] }
        hashes.each do |hash|
          save_transaction(hash, block)
        end
      end

      # save blocks and transactions, from next db block to last block in chain
      def save_blocks_with_transactions
        block_number_hex_str = CitaSync::Api.cita_block_number["result"]
        block_number = CitaSync::Basic.hex_str_to_number(block_number_hex_str)

        # current biggest block number in database
        last_block = ::Block.order(block_number: :desc).first
        last_block_number = last_block&.block_number || -1
        ((last_block_number + 1)..block_number).each do |num|
          hex_str = CitaSync::Basic.number_to_hex_str(num)
          save_block_with_transactions(hex_str)
        end
      end

    end

  end
end
