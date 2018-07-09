namespace :daemons do
  namespace :sync do
    task :start => :environment do
      puts `ruby #{Rails.root.join("lib", "sync_control.rb")} start`
    end

    task :status => :environment do
      puts `ruby #{Rails.root.join("lib", "sync_control.rb")} status`
    end

    task :stop => :environment do
      puts `ruby #{Rails.root.join("lib", "sync_control.rb")} stop`
    end

    task :restart => :environment do
      puts `ruby #{Rails.root.join("lib", "sync_control.rb")} restart`
    end

  end
end
