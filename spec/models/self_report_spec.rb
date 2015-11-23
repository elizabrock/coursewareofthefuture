require 'rails_helper'

describe SelfReport do
  it { should validate_presence_of :user }
  it { should validate_presence_of :date }
  it { should validate_uniqueness_of(:date).scoped_to(:user_id) }
  it { should validate_presence_of :hours_coding }
  it { should validate_presence_of :hours_learning }
  it { should validate_presence_of :hours_slept }
  it { should validate_presence_of :hours_slept }

  describe "Total hours cannot be more than 24" do
    let(:over_twenty_four_student){ Fabricate.build(:self_report, hours_coding: 10, hours_learning: 10, hours_slept: 10) }
    let(:twenty_four_student){ Fabricate(:self_report, hours_coding: 8, hours_learning: 8, hours_slept: 8) }
    let(:under_twenty_four_student){ Fabricate(:self_report, hours_coding: 5, hours_learning: 5, hours_slept: 5) }
    context "Total hours are more_than_twenty_four" do
      it "should not save if over 24 hours" do
        over_twenty_four_student.save
        over_twenty_four_student.errors[:base].should == ["Total hours cannot be greater than 24"]
        SelfReport.count.should == 0
      end
    end
    context "Total hours are equal_to_twenty_four" do
      it "should save if equaled to 24 hours" do
        twenty_four_student.save
        SelfReport.count.should == 1
      end
    end
    context "Total hours are less_than_twenty_four" do
      it "should save if under 24 hours" do
        under_twenty_four_student.save
        SelfReport.count.should == 1
      end
    end
  end

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
