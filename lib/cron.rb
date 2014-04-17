class Cron
  def self.run!
    SelfReport.send_student_reminders!
  end
end
