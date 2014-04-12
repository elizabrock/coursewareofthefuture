def path_to path_descriptor
  case path_descriptor
  when "the homepage"
    root_path
  when 'my profile page'
    user_path(@user)
  when /(.*?)'s profile page/
    user = User.where(username: $1 ).first
    user_path(user)
  when /the student list page/
    users_path
  when /the course calendar for (.*)/
    course = Course.find_by_title($1)
    course_calendar_path(course)
  when /the (.*) course page/
    course = Course.find_by_title($1)
    course_path(course)
  when /the assignments page/
    course_assignments_path(@course)
  when /the Peers tab/
    course_enrollments_path(@course)
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
