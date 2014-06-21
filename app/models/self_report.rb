class SelfReport < ActiveRecord::Base
  belongs_to :user, inverse_of: :self_reports

  validates_presence_of :date
  validates_uniqueness_of :date, scope: :user
  validates_presence_of :hours_coding
  validates_presence_of :hours_learning
  validates_presence_of :hours_slept
  validates_inclusion_of :attended, :in => [true, false], message: "must be selected"
  validate :total_hours
  validates_presence_of :user

  def self.random_reminder
    if rand(100) < 80
      "It's that time of day again!"
    else
      [ "It's 8:00. Do you know where your Self-Report is?",
        "Please enter yesterday's Self-Report",
        "You're gonna need a bigger Self-Report",
        "I love the smell of a Self-Report in the morning",
        "Love means never having to say you're sorry you didn't enter your Self-Report",
        "Go ahead, make my day. Enter your Self-Report",
        "Louis, I think this is the beginning of a beautiful friendship... assuming you enter a Self-Report",
        "Show me the money! And a Self-Report",
        "If you build a Self-Report, he will come",
        "A census taker once tried to test me. I ate his Self-Report with some fava beans and a nice Chianti.",
        "You can't handle the Self-Report!",
        "Mama always said life was like a box of Self-Reports. You never know what you're gonna get.",
        "Self-Reports, for lack of a better word, is good.",
        "Keep your friends close, but your Self-Reports closer.",
        "Say 'hello' to my little Self-Report!",
        "Ich bin ein Self-Report",
        "Oh, no, it wasn't the Self-Reports. It was Beauty killed the Beast.",
        "I feel the need—the need for a Self-Report!",
        "Carpe diem. Seize the day, boys. Make your Self-Reports extraordinary.",
        "Nobody puts a Self-Report in a corner.",
        "I got a fever.. And the only prescription.. Is more self-reports."].sample
    end
  end

  def self.send_student_reminders!
    Course.active.all.each do |course|
      course.users.except_observers.each do |user|
        unless user.self_reports.where(date: 1.day.ago.beginning_of_day).count > 0
          SelfReportsMailer.reminder(user, course).deliver
        end
      end
    end
  end

  private

  def total_hours
    total_hours = [hours_slept, hours_coding, hours_learning].compact.sum
    if total_hours > 24
      errors.add(:base, "Total hours cannot be greater than 24")
    elsif total_hours <= 0
      errors.add(:base, "Total hours must be greater than 0")
    end
  end
end
