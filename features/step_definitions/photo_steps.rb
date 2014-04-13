Then(/^my photo should be "(.*?)"$/) do |filename|
  page.find('img.profile_photo')['src'].should have_content(filename)
end
