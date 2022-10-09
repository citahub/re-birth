# frozen_string_literal: true

namespace :transactions do
  desc "add errorMessage to old transactions data"
  task add_error_message: :environment do
    Transaction.where(error_message: nil).find_each do |tx|
      receipt = CitaSync::Api.get_transaction_receipt(tx.tx_hash)
      error_message = receipt.dig("result", "errorMessage")
      tx.update!(error_message: error_message) unless error_message.nil?
    end
  end
end
