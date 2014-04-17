class SelfReport < ActiveRecord::Base
  belongs_to :user, inverse_of: :self_reports

  validates_presence_of :user
  validates_presence_of :date

  def self.send_student_reminders!
    Course.active.all.each do |course|
      course.users.each do |user|
        unless user.self_reports.where(date: Date.today).count > 0
          SelfReportsMailer.reminder(user, course).deliver
        end
      end
    end
  end
end
