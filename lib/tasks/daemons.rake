namespace :daemons do
  namespace :sync do
    desc "start sync process"
    task :start => :environment do
      puts `ruby #{Rails.root.join("lib", "sync_control.rb")} start`
    end

    desc "get sync process status"
    task :status => :environment do
      puts `ruby #{Rails.root.join("lib", "sync_control.rb")} status`
    end

    desc "stop sync process"
    task :stop => :environment do
      puts `ruby #{Rails.root.join("lib", "sync_control.rb")} stop`
    end

    desc "restart sync process"
    task :restart => :environment do
      puts `ruby #{Rails.root.join("lib", "sync_control.rb")} restart`
    end

  end
end
