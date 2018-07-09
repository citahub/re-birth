require 'daemons'
require_relative '../config/environment'

options = {
  log_output: true,
  log_dir: Rails.root.join("log"),
  monitor: true,
  dir: Rails.root.join("tmp", "pids").to_s
}

Daemons.run_proc("#{Rails.env}_sync", options) do
  Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_sync.log"))
  ::CitaSync::Persist.realtime_sync
end
