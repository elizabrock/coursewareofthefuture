class Event < ActiveRecord::Base
  validates_presence_of :course, :date, :summary
  validate :date_matches_course

  belongs_to :course

  private

  def date_matches_course
    return unless course
    if date < course.start_date or date > course.end_date
      errors.add(:date, "must be during the course")
    end
  end
end
