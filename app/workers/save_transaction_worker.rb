# frozen_string_literal: true

class SaveTransactionWorker
  include Sidekiq::Worker

  def perform(hash)
    CitaSync::Persist.save_transaction(hash)
  end
end
