Given(/^I am signed in as (.*)$/) do |name|
  if name == "an instructor"
    @instructor = Fabricate(:instructor)
    visit new_instructor_session_path
    fill_in "Email", with: @instructor.email
    fill_in "Password", with: "password"
    click_button "Login"
  else
    @student = Student.where(name: name).first
    visit new_student_session_path
    fill_in "Email", with: @student.email
    fill_in "Password", with: "password"
    click_button "Sign in"
  end
end
