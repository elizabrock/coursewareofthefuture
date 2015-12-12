require 'rails_helper'

describe MilestoneSubmissionMailer do

  context "#notify_instructors" do

    let!(:instructor1){ Fabricate(:instructor) }
    let(:instructor2){ Fabricate(:instructor) }
    let(:instructor3){ Fabricate(:instructor) }
    let(:student){ Fabricate(:student, name: "Lisa Smith") }
    let(:course){ Fabricate(:course) }
    let(:assignment){ Fabricate(:published_assignment,
                                title: "Test Assignment",
                                course: course,
                                milestones: [
                                  Fabricate.build(:milestone, title: "Milestone Uno")
                                ]) }

    before do
      course.users << [student, instructor1, instructor2]
      instructor3.courses.should be_empty

      milestone_submission = Fabricate(:milestone_submission, milestone: assignment.milestones.first, user: student)
    end

    it "should send 1 email to each instructor" do
      unread_emails_for(instructor1.email).size.should == 1
      unread_emails_for(instructor2.email).size.should == 1
    end

    it "should not send emails to instructors of other courses" do
      unread_emails_for(instructor3.email).size.should == 0
    end

    it "should not send an email to the student" do
      unread_emails_for(student.email).size.should == 0
    end

    it "should have a subject line with the assignment's name in it" do
      open_email(instructor1.email)
      current_email.should have_subject("New Submission for Test Assignment")
    end

    it "should have body text with the student's name and the assignment's name in it" do
      open_email(instructor1.email)
      current_email.should have_body_text("Lisa Smith has submitted Test Assignment: Milestone Uno.")
    end

    it "should link to the assignment page" do
      open_email(instructor1.email)
      current_email.should have_body_text(course_assignment_url(course, assignment))
    end
  end
end
