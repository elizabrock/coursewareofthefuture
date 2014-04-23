class Milestone < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :milestones
  has_many :milestone_submissions

  validate :deadline_must_be_appropriate, if: :deadline
  validates_presence_of :assignment
  validates_presence_of :deadline

  private

  def deadline_must_be_appropriate
    if assignment.course.start_date > deadline or deadline > assignment.course.end_date.end_of_day
      errors.add(:deadline, "Must be in the course timeframe of #{assignment.course.start_date} to #{assignment.course.end_date}")
    end
  end
end
