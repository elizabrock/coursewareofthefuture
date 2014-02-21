When(/^I go to the homepage$/) do
  visit root_path
end

Given(/^I am on the sign in page$/) do
  visit new_student_session_path
end

