# frozen_string_literal: true

class SaveDecodeTransactionWorker
  include Sidekiq::Worker

  def perform(transaction_hash)
    tx = Transaction.find(transaction_hash)

    ContractAbi.save_contract_info(tx)

    decode_tx = DecodeTransaction.save_decode_transaction(tx)

    SaveDecodedInfoWorker.perform_async(transaction_hash) if decode_tx
  end

end
