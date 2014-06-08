class PrereadingsController < ApplicationController
  expose(:prereading){ current_user.milestone_submissions }
  expose(:prereading, attributes: :prereading_params)

  def create
    prereading.save!
    redirect_to :back, notice: "Prereading Has been created"
    # milestone_submission.save!
    # redirect_to :back, notice: "#{milestone_submission.milestone.title} has been submitted for grading."
  end

  private

  def prereading_params
    params.require(:prereading).permit(:url, :note, :assignment_id)
  end
end
