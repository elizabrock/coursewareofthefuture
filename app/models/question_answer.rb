class QuestionAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :quiz_submission, inverse_of: :question_answers

  validates_presence_of :question
  validates_presence_of :quiz_submission
  validates_presence_of :answer, if: :quiz_being_submitted?

  scope :for, ->(question){ where(question_id: question.id).limit(1) }

  def prepare_for_submission!
    @quiz_being_submitted = true
    self.prepare_grade!
  end

  def prepare_grade!
    if question.boolean?
      correct = question.correct_answer?(self.answer)
      self.score = correct ? 1 : -1
    else
      self.score = 0
    end
  end

  private

  def quiz_being_submitted?
    @quiz_being_submitted
  end
end
