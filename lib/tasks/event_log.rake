namespace :event_log do
  desc "create a event log model and migration"
  task :create, [:file_name] => :environment do |task, args|
    puts EventLogProcess.new(args[:file_name]).generate_model
    puts EventLog.find_by(name: args[:file_name])&.update(block_number: nil)
    puts `bundle exec rake db:migrate`
  end
end
