require 'cron'

When(/^the cron job runs$/) do
  Cron.run!
end
