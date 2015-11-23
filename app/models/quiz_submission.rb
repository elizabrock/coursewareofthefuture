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

  def formatted_grade
    graded? ? "#{grade}%" : "Pending"
  end

  def populate_from_quiz
    return unless quiz
    quiz.questions.each do |question|
      unless self.question_answers.find{ |qa| qa.question == question }
        self.question_answers.build(question: question)
      end
    end
    self
  end

  def update_grade!
    return unless submitted_at.present?
    return if question_answers.any?(&:ungraded?)
    new_grade = ((question_answers.sum(:score) +  question_answers.count) * 100) / (question_answers.count * 2)
    notify_student = new_grade != grade
    update_attributes!(grade: new_grade, graded: true)
    notify_student! if notify_student
  end

  def submit!
    self.submitted_at = Time.now
    self.graded = false
    self.question_answers.each(&:prepare_for_submission!)
    self.save
  end

  def submitted?
    self.submitted_at.present?
  end

  private

  def notify_student!
    QuizMailer.notify_student(self).deliver_now
  end
end
