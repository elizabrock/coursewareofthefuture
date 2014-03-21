Given(/^that it is (\d+)\/(\d+)\/(\d+)$/) do |year, month, day|
  Timecop.travel(year.to_i, month.to_i, day.to_i)
end
