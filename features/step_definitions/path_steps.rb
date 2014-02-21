def path_to path_descriptor
  case path_descriptor
  when "the homepage"
    root_path
  when "the sign in page"
    new_student_session_path
  when 'my profile page'
    student_path(@student)
  when 'the student list page'
    students_path
  when /(.*?)'s profile page/
    user = User.where(username: $1 ).first
    user_path(user)
  else
    path_descriptor
  end
end

When /^I (?:go to|am on) (.*)$/ do |path_descriptor|
  visit path_to(path_descriptor)
end

Then /^I should be on (.*)$/ do |path_descriptor|
  current_path.should == path_to(path_descriptor)
end
