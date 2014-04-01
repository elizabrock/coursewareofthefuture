class Quiz < ActiveRecord::Base
  belongs_to :course
  has_many :questions, inverse_of: :quiz
  has_many :quiz_submissions

  validates_presence_of :title
  accepts_nested_attributes_for :questions, reject_if: :all_blank

  scope :published,   ->{ where("deadline is not null") }
  scope :unpublished, ->{ where("deadline is null") }

  def published?
    self.deadline.present?
  end
end
