Given(/^I have a photo$/) do
  @user.avatar_url = "www.path.to/image.jpg"
  @user.save
end

Given(/^my photo is confirmed$/) do
  @user.avatar_confirmed = true
  @user.save
end

Then(/^my photo should be "(.*?)"$/) do |arg1|
  page.find('img#avatar')['src'].should have_content(arg1)
end
