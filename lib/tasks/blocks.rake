namespace :blocks do
  desc "clean all blocks"
  task :clean => :environment do
    puts Block.delete_all
  end
end
