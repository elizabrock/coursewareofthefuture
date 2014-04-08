class QuizSubmission < ActiveRecord::Base
  belongs_to :quiz
  has_many :question_answers, inverse_of: :quiz_submission
  has_many :questions, through: :question_answers
  belongs_to :user

  accepts_nested_attributes_for :question_answers
  validates_associated :question_answers
  validates_presence_of :question_answers
  validates_presence_of :quiz
  validates_presence_of :user

  before_validation :populate_from_quiz, on: :create

  scope :for, ->(quiz){ where(quiz: quiz) }
  scope :gradeable, ->{ where("submitted_at is not null") }
  scope :in_progress, ->{ where("submitted_at is null") }

  def populate_from_quiz
    return unless quiz
    quiz.questions.each do |question|
      unless self.question_answers.find{ |qa| qa.question == question }
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
