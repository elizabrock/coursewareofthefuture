require 'spec_helper'
#include Rails.application.routes.url_helpers

describe MilestoneSubmission do
  it { should belong_to :milestone }
  it { should validate_presence_of :milestone }
  it { should validate_presence_of :user }
  it { should validate_presence_of :repository }
  describe "instructor notification on submitted assignment milestone" do
    let!(:instructor){ Fabricate(:user, name: "Test Instructor", email: "instructor@sample.com", instructor: true) }
    let!(:course){ Fabricate(:course) }
    let!(:assignment){ Fabricate(:assignment, title: "Test Assignment", course: course) }
    before do
      reset_mailer
      student = Fabricate(:user, name: "Test Student", email: "student@sample.com")
      course.users << [student, instructor]
      milestone = Fabricate(:milestone, assignment: assignment, deadline: Time.new)
      milestone_submission = Fabricate(:milestone_submission, user: student, milestone: milestone, repository: "foo/bar")
    end
    it "should have sent only one email to the instructor" do
      unread_emails_for(instructor.email).size.should == 1
    end
    it "should have a subject line with the assignment's name in it" do
      open_email(instructor.email)
      current_email.should have_subject("New Submission for Test Assignment")
    end
    it "should have body text with the student's name and the assignment's name in it" do
      open_email(instructor.email)
      current_email.should have_body_text("Test Student has submitted something to Test Assignment.")
    end
    it "should link to the assignment page" do
      open_email(instructor.email)
      current_email.should have_body_text(/#{course_assignment_url(course, assignment)}/)
    end
  end
end
