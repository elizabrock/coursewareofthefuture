require 'spec_helper'

describe SelfReport do
  it { should validate_presence_of :user }
  it { should validate_presence_of :date }

  describe ".send_student_reminders!" do
    def do_action
      SelfReport.send_student_reminders!
    end
    let(:course){ Fabricate(:course, start_date: 2.days.ago) }
    let(:old_course){ Fabricate(:past_course) }
    let(:old_course_student){ Fabricate(:student, courses: [old_course]) }
    let(:truant_student){ Fabricate(:student, courses: [course]) }
    let(:barely_truant_student){ Fabricate(:student, courses: [course]) }
    let(:uptodate_student){ Fabricate(:student, courses: [course]) }
    let(:unenrolled_student){ Fabricate(:student, courses: []) }
    context "when multiple students are missing their self-reports" do
      before do
        truant_student
        unenrolled_student
        old_course_student
        Fabricate(:self_report, user: barely_truant_student, date: 1.day.ago)
        Fabricate(:self_report, user: uptodate_student, date: 1.day.ago.beginning_of_day)
        do_action
      end
      it { unread_emails_for(truant_student.email).size.should == 1 }
      it { unread_emails_for(barely_truant_student.email).size.should == 1 }
      it { unread_emails_for(uptodate_student.email).size.should == 0 }
      it { unread_emails_for(unenrolled_student.email).size.should == 0 }
    end
    context "when no students are missing reports" do
      before do
        Fabricate(:self_report, user: uptodate_student, date: 1.day.ago.beginning_of_day)
        do_action
      end
      it "shouldn't send any emails" do
        unread_emails_for(uptodate_student.email).size.should == 0
      end
    end
  end
end
