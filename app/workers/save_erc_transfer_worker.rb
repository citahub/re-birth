# frozen_string_literal: true

class SaveErcTransferWorker
  include Sidekiq::Worker

  def perform(transaction_hash, transaction_log_index)
    event_log = EventLog.find_by(transaction_hash: transaction_hash, transaction_log_index: transaction_log_index)
    return if event_log.nil?

    Erc20Transfer.save_from_event_log(event_log)
  end
end
