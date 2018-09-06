require 'daemons'
require_relative '../config/environment'

options = {
  log_output: false,
  log_dir: Rails.root.join("log"),
  monitor: true,
  dir: Rails.root.join("tmp", "pids").to_s
}

# Run a process to real time sync with chain, and monitoring it.
Daemons.run_proc("#{Rails.env}_sync", options) do
  Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_sync.log"))
  ::CitaSync::Persist.realtime_sync
end
