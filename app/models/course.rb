class Course < ActiveRecord::Base
  validates_presence_of :title, :syllabus, :start_date, :end_date

  has_many :events
  has_many :enrollments
  has_many :users, through: :enrollments

  scope :active_or_future, ->{ where("courses.end_date >= ?", Date.today) }
end
