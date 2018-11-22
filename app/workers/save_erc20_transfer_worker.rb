# frozen_string_literal: true

class SaveErc20TransferWorker
  include Sidekiq::Worker

  def perform(event_log_id)
    event_log = EventLog.find_by(id: event_log_id)
    return if event_log.nil?

    if Erc20Transfer.exists?(address: event_log.address&.downcase) && Erc20Transfer.transfer?(event_log.topics)
      Erc20Transfer.save_from_event_log(event_log)
    end
  end
end
