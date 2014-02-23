class Course < ActiveRecord::Base
  validates_presence_of :title, :syllabus, :start_date, :end_date
  validate :only_one_active_course

  has_many :events

  def self.active
    @@active_course = Course.where(active_course: true).first
  end

  private

  def only_one_active_course
    if Course.active and Course.active != self
      errors.add(:active_course, "can't be active at the same time as another course")
    end
  end
end
