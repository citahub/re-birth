# frozen_string_literal: true

class SaveEventLogsWorker
  include Sidekiq::Worker

  def perform(logs)
    CitaSync::Persist.save_event_logs(logs)
  end
end
