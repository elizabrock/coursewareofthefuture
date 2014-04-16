class QuizMailer < ActionMailer::Base
  default from: "eliza@elizabrocksoftware.com"

  def notify_student(quiz_submission)
    @quiz_submission = quiz_submission
    @course = @quiz_submission.quiz.course

    subject = "#{@quiz_submission.quiz.title} Graded"

    mail to: @quiz_submission.user.email, subject: subject
  end
end
