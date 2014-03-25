class Milestone < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :milestones

  validates_presence_of :assignment
  validates_inclusion_of :deadline,
    in: ->(m){ (m.assignment.course.start_date..m.assignment.course.end_date) },
    message: "Must be in the course timeframe"
  validates_inclusion_of :deadline,
    in: ->(m){ (Date.today..m.assignment.course.end_date) },
    message: "Must be in the future"
end
