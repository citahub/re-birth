# frozen_string_literal: true

class SaveErc20TransferWorker
  include Sidekiq::Worker

  def perform(transaction_hash, transaction_log_index)
    event_log = EventLog.find_by(transaction_hash: transaction_hash, transaction_log_index: transaction_log_index)
    return if event_log.nil?

    Erc20Transfer.save_from_event_log(event_log) if Erc20Transfer.exists?(address: event_log.address&.downcase) && Erc20Transfer.transfer?(event_log.topics)
  end
end
