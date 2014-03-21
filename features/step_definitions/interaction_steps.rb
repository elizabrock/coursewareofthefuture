When(/^I (?:follow|click) "(.*?)"$/) do |text|
  click_link text
end

When(/^I fill in "(.*?)" for "(.*?)"$/) do |value, label|
  fill_in(label, with: value)
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |label, value|
  fill_in(label, with: value)
end

When(/^I press "(.*?)"$/) do |text|
  click_button text
end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content(text)
end

Then(/^I should not see "(.*?)"$/) do |text|
  page.should_not have_content(text)
end

Then /^(?:|I )should see the following list:$/ do |table|
  table.raw.each_with_index do |content, row|
    page.should have_xpath("//ul/li[#{row+1}][contains(normalize-space(.), '#{content[0]}')] | //ol/li[#{row+1}][contains(normalize-space(.), '#{content[0]}')] ")
  end
end

When(/^I select (\d+) (\w+) (\d+) from "(.*?)"$/) do |year, month, day, tag|
  select year, from: "#{tag}_1i"
  select month, from: "#{tag}_2i"
  select day, from: "#{tag}_3i"
end

When(/^I check "(.*?)"$/) do |label|
  check label
end

Then(/^I should see a "(.*?)" tag with the content "(.*?)"$/) do |tag, text|
  page.should have_css(tag, text: text)
end

Then /^(?:|I )should see the following:$/ do |table|
  table.raw.each_with_index do |content, row|
    page.should have_content(content[0])
  end
end

Then(/^I should see the following calendar entries:$/) do |table|
  table.raw.each do |row|
    date = row[0]
    notice = row[1]
    page.should have_css("td[data-date='#{date}']", text: notice)
  end
end
