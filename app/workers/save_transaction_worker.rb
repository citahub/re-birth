# frozen_string_literal: true

class SaveTransactionWorker
  include Sidekiq::Worker

  def perform(tx_data, index, block_number_hex_str, block_hash)
    CitaSync::Persist.save_transaction(tx_data, index, block_number_hex_str, block_hash)
  end
end
