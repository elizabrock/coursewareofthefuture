require "spec_helper"

feature "Instructor is notified of submitted assignment milestone" do
  scenario "email gets sent to all instructors when milestone submission is created" do
    instructor = Fabricate(:user, name: "Test Instructor", email: "instructor@sample.com", instructor: true)
    student = Fabricate(:user, name: "Test Student", email: "student@sample.com")
    course = Fabricate(:course)
    Fabricate(:enrollment, user: student, course: course)
    Fabricate(:enrollment, user: instructor, course: course)
    assignment = Fabricate(:assignment, title: "Test Assignment", course: course)
    milestone = Fabricate(:milestone, assignment: assignment, deadline: Time.new)
    milestone_submission = Fabricate(:milestone_submission, user: student, milestone: milestone, repository: "foo/bar")

    unread_emails_for(instructor.email).size.should == 1
    open_email(instructor.email)
    current_email.should have_subject("New Submission for Test Assignment")
    current_email.should_not have_subject("intentionally bad subject line")
    current_email.should have_body_text("Test Student has submitted something to Test Assignment.")
  end
end
