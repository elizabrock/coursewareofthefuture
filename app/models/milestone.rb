class Milestone < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :milestones

  validate :deadline_must_be_appropriate
  validates_presence_of :assignment

  private

  def deadline_must_be_appropriate
    if assignment.course.start_date > deadline or deadline > assignment.course.end_date.end_of_day
      errors.add(:deadline, "Must be in the course timeframe of #{assignment.course.start_date} to #{assignment.course.end_date}")
    elsif Date.today > deadline
      errors.add(:deadline, "Must be in the future. (It is currently #{Time.now})")
    end
  end
end
