require 'cron'

desc "Run cron job"
task :cron => :environment do
  Cron.run!
end
