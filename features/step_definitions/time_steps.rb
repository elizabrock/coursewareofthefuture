Given(/^that it is (\d+)\/(\d+)\/(\d+)$/) do |year, month, day|
  t = Time.new(year.to_i, month.to_i, day.to_i)
  Timecop.travel(t)
end

Given(/^that it is (\d+)\/(\d+)\/(\d+) (\d+):(\d+)PM$/) do |year, month, day, hour, minute|
  t = Time.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i)
  Timecop.travel(t)
end
