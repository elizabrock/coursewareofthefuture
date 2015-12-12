class Milestone < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :milestones
  has_many :milestone_submissions

  validate :deadline_must_be_appropriate, if: [:assignment, :deadline]
  validates_presence_of :assignment, :instructions, :title
  validates_presence_of :deadline, if: ->{ assignment.try(:published?) }

  default_scope ->{ order("deadline ASC") }

  before_create :set_default_corequisite_fullpaths

  def corequisites
    return [] unless corequisite_fullpaths.present?
    corequisite_fullpaths.find_all{|fp| !fp.blank? }.map{ |fp| Corequisite.new(fp) }
  end

  def publishable?
    deadline.present?
  end

  def title_for_instructor
    student_count = assignment.course.enrollments.count
    submitted_count = milestone_submissions.count
    "#{title} (#{submitted_count} completed, #{student_count - submitted_count} incomplete, due #{deadline})"
  end

  private

  def deadline_must_be_appropriate
    return unless assignment.start_date.present?
    if assignment.start_date > deadline or deadline > assignment.course.end_date.end_of_day
      errors.add(:deadline, "must be in the assignment timeframe of #{assignment.start_date} to #{assignment.course.end_date}")
    end
  end

  def set_default_corequisite_fullpaths
    self.corequisite_fullpaths ||= []
  end
end
