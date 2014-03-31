class QuestionAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :quiz_submission, inverse_of: :question_answers

  validates_presence_of :question
  validates_presence_of :quiz_submission
  validates_presence_of :answer, if: :quiz_being_submitted?

  private

  def quiz_being_submitted?
    self.quiz_submission.try(:submitted?)
  end
end
