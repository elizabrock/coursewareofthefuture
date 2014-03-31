class QuizSubmissionsController < ApplicationController
  expose(:quizzes){ current_course.quizzes }
  expose(:quiz)
  expose(:quiz_submissions){ current_user.quiz_submissions }
  expose(:quiz_submission){ quiz_submissions.for(quiz).first }

  def create
    quiz_submission = quiz_submissions.build
    quiz_submission.populate_from_quiz(quiz)
    quiz_submission.save!
    redirect_to edit_course_quiz_submission_path(current_course, quiz)
  end

  def update
    quiz_submission.update_attributes(quiz_submission_params)
    if params[:commit] == "Finish Quiz"
      if quiz_submission.submit!
        redirect_to course_assignments_path(current_course), notice: "Your quiz has been submitted for grading."
      else
        flash.alert = "Your quiz cannot yet be submitted for grading."
        render :edit
      end
    else
      redirect_to course_assignments_path(current_course), notice: "Your quiz progress has been saved."
    end
  end

  private

  def quiz_submission_params
    params.require(:quiz_submission).permit(question_answers_attributes: [:id, :question_id, :answer])
  end
end
