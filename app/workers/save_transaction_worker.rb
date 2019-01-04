# frozen_string_literal: true

class SaveTransactionWorker
  include Sidekiq::Worker

  def perform(tx_data, index, block_number_hex_str, block_hash, block_id)
    CitaSync::Persist.save_transaction(tx_data, index, block_number_hex_str, block_hash, block_id)
  end
end
