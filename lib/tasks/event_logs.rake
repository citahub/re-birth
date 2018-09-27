# frozen_string_literal: true

namespace :event_logs do
  desc "save transaction's event log that already synced"
  task fix_old: :environment do
    Transaction.find_each do |t|
      receipt = CitaSync::Api.get_transaction_receipt(t.cita_hash)
      logs = receipt.dig "result", "logs"
      next if logs.blank?

      CitaSync::Persist.save_event_logs(logs)
    end
  end
end
