class SelfReportsMailer < ActionMailer::Base
  def reminder(user, course)
    @course = course
    mail to: user.email, subject: "Reminder: Enter Your Self-Report"
  end
end
