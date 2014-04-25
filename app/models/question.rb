class Question < ActiveRecord::Base
  belongs_to :quiz, inverse_of: :questions
  has_many :question_answers

  BOOLEAN = "boolean"
  FREE_TEXT = "free_text"
  TRUE_VALUES = ["true", "True", true, "t"]
  FALSE_VALUES = ["false", "False", false, "f"]

  validates_presence_of :quiz, :question, :question_type, :correct_answer
  validates_inclusion_of :question_type, in: [BOOLEAN, FREE_TEXT]
  validates_inclusion_of :correct_answer, in: (TRUE_VALUES + FALSE_VALUES), if: Proc.new{|q| q.question_type == 'boolean' }

  accepts_nested_attributes_for :question_answers

  default_scope { order("id ASC") }

  def boolean?
    self.question_type == BOOLEAN
  end

  def correct_answer?(value)
    as_boolean(self.correct_answer) == as_boolean(value)
  end

  def as_boolean(value)
    return true if value.in? TRUE_VALUES
    return false if value.in? FALSE_VALUES
    nil
  end
end
