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
