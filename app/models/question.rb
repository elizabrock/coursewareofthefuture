class Question < ActiveRecord::Base
  belongs_to :quiz, inverse_of: :questions

  validates_presence_of :quiz, :question, :question_type, :correct_answer
  validates_inclusion_of :question_type, in: %w{boolean free_text}
  validates_inclusion_of :correct_answer, in: %w{true false True False}, if: Proc.new{|q| q.question_type == 'boolean' }
end
