class Course < ActiveRecord::Base
  validates_presence_of :title, :start_date, :end_date, :source_repository
  validate :end_date_must_be_appropriate, if: [:start_date, :end_date]

  has_many :assignments
  has_many :covered_materials
  has_many :enrollments
  has_many :events
  has_many :milestones, through: :assignments
  has_many :quizzes
  has_many :users, through: :enrollments

  scope :active, ->{ active_or_future.where("courses.start_date <= ?", Date.today) }
  scope :active_or_future, ->{ where("courses.end_date >= ?", Date.today) }

  private

  def end_date_must_be_appropriate
    if start_date >= end_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
