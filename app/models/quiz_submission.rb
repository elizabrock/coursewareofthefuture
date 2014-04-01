class QuizSubmission < ActiveRecord::Base
  belongs_to :quiz
  has_many :question_answers, inverse_of: :quiz_submission
  has_many :questions, through: :question_answers
  belongs_to :user

  accepts_nested_attributes_for :question_answers
  validates_associated :question_answers

  scope :for, ->(quiz){ where(quiz: quiz) }
  scope :ready_to_grade, ->{ where("submitted_at is not null").where("graded != true") }

  def populate_from_quiz(quiz)
    self.quiz = quiz
    quiz.questions.each do |question|
      unless self.questions.include? question
        self.question_answers.build(question: question)
      end
    end
    self
  end

  def submit!
    self.submitted_at = Time.now
    self.question_answers.each(&:prepare_for_submission!)
    self.save
  end

  def submitted?
    self.submitted_at.present?
  end
end
