require 'rails_helper'
require 'cron'

feature "Student is reminded of daily reports" do
  # Acceptance Criteria: A reminder email is sent to students at 9pm each evening if no form has been submitted for the previous day.

  let!(:cohort4){ Fabricate(:course, title: "Cohort 4", start_date: "2013/03/11", end_date: "2013/06/20") }
  let(:student){ Fabricate(:student, courses: [cohort4]) }

  background do
    signin_as student
    reset_mailer
  end

  scenario "Reminder email is sent on day-of" do
    Timecop.travel(Time.new(2013, 03, 11, 8, 00)) do
      Cron.run!
      expect(unread_emails_for(student.email).size).to eql 1
      open_email(student.email)
      expect(current_email).to have_subject "Reminder: Enter Your Self-Report"
      visit_in_email "Head to the Course Calendar"
      expect(current_path).to eql course_calendar_path(cohort4)
    end
  end

  scenario "Reminder email isn't sent if the student is an observer" do
    student.become_observer!
    Timecop.travel(Time.new(2013, 03, 11, 8, 00)) do
      Cron.run!
      expect(unread_emails_for(student.email).size).to eql 0
      student.update_attribute(:observer, false)
      Cron.run!
      expect(unread_emails_for(student.email).size).to eql 1
    end
  end

  scenario "Reminder email is not sent if the self-report has been entered" do
    Timecop.travel(Time.new(2013, 03, 11, 8, 00)) do
      Fabricate(:self_report,
                date: "2013/03/10",
                attended: "false",
                hours_coding: 5, hours_slept: 9, hours_learning: 0, user: student)
      Cron.run!
      expect(unread_emails_for(student.email).size).to eql 0
    end
  end

  scenario "Reminder email when there are multiple missing days" do
    Timecop.travel(Time.new(2013, 03, 15, 8, 00)) do
      Fabricate(:self_report,
                date: "2013/03/12",
                attended: false,
                hours_coding: 5, hours_slept: 9, hours_learning: 0, user: student)
      Fabricate(:self_report,
                date: "2013/03/11",
                attended: true,
                hours_coding: 2, hours_slept: 7.5, hours_learning: 4, user: student)
      Cron.run!
      expect(unread_emails_for(student.email).size).to eql 1
      open_email(student.email)
      expect(current_email).to have_subject "Reminder: Enter Your Self-Report"
      visit_in_email "Head to the Course Calendar"
      expect(current_path).to eql course_calendar_path(cohort4)
    end
  end
end
