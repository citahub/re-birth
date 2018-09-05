namespace :event_log do
  desc "create a event log model and migration"
  task :create, [:file_name] => :environment do |task, args|
    puts EventLogProcess.new(args[:file_name]).create_table
  end
end
