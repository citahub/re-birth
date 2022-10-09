# frozen_string_literal: true

require "daemons"
require_relative "../config/environment"

# written log;includes extracting all open files before fork, and reopening them later.
@files_to_reopen = []
ObjectSpace.each_object(File) do |file|
  @files_to_reopen << file unless file.closed?
end

options = {
  log_output: false,
  log_dir: Rails.root.join("log"),
  monitor: true,
  dir: Rails.root.join("tmp", "pids").to_s
}

# Run a process to real time sync with chain, and monitoring it.
Daemons.run_proc("#{Rails.env}_sync", options) do
  @files_to_reopen.each do |file|
    file.reopen file.path, 'a+'
    file.sync = true
  end

  # Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_sync.log"))
  ::CitaSync::Persist.realtime_sync
end

# Run a process to sync event logs
# unless EventLogProcessor.tables.empty?
#   Daemons.run_proc("#{Rails.env}_event_log", options) do
#     @files_to_reopen.each do |file|
#       file.reopen file.path, 'a+'
#       file.sync = true
#     end

#     # Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_event_log.log"))
#     EventLogProcessor.sync_all
#   end
# end
