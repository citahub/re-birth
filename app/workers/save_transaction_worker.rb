# frozen_string_literal: true

class SaveTransactionWorker
  include Sidekiq::Worker

  def perform(tx_data, index, block_number, block_hash, timestamp)
    # compatibility
    block_number = HexUtils.to_decimal(block_number) if block_number.is_a?(String) && block_hash.start_with?("0x")

    CitaSync::Persist.save_transaction(tx_data, index, block_number, block_hash, timestamp)
  end
end
