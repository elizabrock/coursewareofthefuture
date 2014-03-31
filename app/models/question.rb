class Question < ActiveRecord::Base
  belongs_to :quiz, inverse_of: :questions

  BOOLEAN = "boolean"
  FREE_TEXT = "free_text"

  validates_presence_of :quiz, :question, :question_type, :correct_answer
  validates_inclusion_of :question_type, in: [BOOLEAN, FREE_TEXT]
  validates_inclusion_of :correct_answer, in: %w{true false True False}, if: Proc.new{|q| q.question_type == 'boolean' }

  def boolean?
    self.question_type == BOOLEAN
  end
end
