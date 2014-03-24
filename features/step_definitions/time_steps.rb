Given(/^that it is (\d+)\/(\d+)\/(\d+)$/) do |year, month, day|
  t = Time.new(year.to_i, month.to_i, day.to_i)
  Timecop.travel(t)
end
