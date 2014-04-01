class QuestionGradesController < ApplicationController
  expose(:question, attributes: :question_params)
  expose(:quiz){ question.quiz }
  expose(:current_course){ quiz.course }

  before_filter :require_instructor!

  def update
    question.save!
    flash.notice = "Grades for '#{question.question}' have been updated."
    redirect_to grade_course_quiz_path(current_course, quiz)
  end

  private

  def question_params
    params.require(:question).permit(question_answers_attributes: [:id, :score])
  end
end
