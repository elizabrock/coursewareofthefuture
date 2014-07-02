class Quiz < ActiveRecord::Base
  belongs_to :course
  has_many :questions, inverse_of: :quiz
  has_many :quiz_submissions

  validates_presence_of :title
  validates_presence_of :course
  accepts_nested_attributes_for :questions, reject_if: :all_blank

  scope :published,   ->{ where(published: true) }
  scope :unpublished, ->{ where("published is null or published = false") }

  def title_for_instructor
    if published?
      "#{title} (#{quiz_submissions.gradeable.count} completed, #{quiz_submissions.in_progress.count} in progress)"
    elsif deadline.present?
      "#{title} (unpublished, due #{deadline})"
    else
      "#{title} (unpublished)"
    end
  end
end
