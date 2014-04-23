class MilestoneSubmissionsController < ApplicationController
  expose(:milestone_submissions){ current_user.milestone_submissions }
  expose(:milestone_submission, attributes: :milestone_submission_params)

  def create
    milestone_submission.save!
    redirect_to :back, notice: "#{milestone_submission.milestone.title} has been submitted for grading."
  end

  private

  def milestone_submission_params
    params.require(:milestone_submission).permit(:repository, :milestone_id)
  end
end
