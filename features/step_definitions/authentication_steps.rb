Given(/^I am signed in as (.*)$/) do |name|
  @student = Student.where(name: name).first
  visit new_student_session_path
  fill_in "Email", with: @student.email
  fill_in "Password", with: "password"
  click_button "Sign in"
end
