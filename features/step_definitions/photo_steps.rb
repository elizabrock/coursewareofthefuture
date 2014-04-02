Then(/^my photo should be "(.*?)"$/) do |arg1|
  page.find('img#avatar')['src'].should have_content(arg1)
end
