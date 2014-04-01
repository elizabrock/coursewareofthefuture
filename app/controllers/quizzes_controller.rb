class QuizzesController < ApplicationController
  expose(:quizzes){ current_course.quizzes }
  expose(:quiz, attributes: :quiz_params)
  expose(:quiz_submissions){ quiz.quiz_submissions }

  def create
    if quiz.save
      redirect_to edit_course_quiz_path(current_course, quiz), notice: "Your quiz has been created. Add questions and then publish it."
    else
      flash.alert = "Your quiz could not be saved."
      render :new
    end
  end

  def edit
    quiz.questions.build
  end

  def update
    if quiz.save
      if quiz.published?
        redirect_to course_assignments_path(current_course), notice: "Your quiz has been published."
      else
        redirect_to edit_course_quiz_path(current_course, quiz), notice: "Your quiz has been updated."
      end
    else
      flash.alert = "Your quiz could not be updated."
      render :edit
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:title, :deadline, questions_attributes: [:id, :question, :question_type, :correct_answer])
  end
end
