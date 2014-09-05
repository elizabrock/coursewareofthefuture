class StudentsController < ApplicationController
  expose(:students){ User.students }

  skip_before_filter :require_profile!
  skip_before_filter :authenticate!

  def index
  end

  def show
    @student = User.find_by_id(params[:id])
    @milestone_submissions = MilestoneSubmission.where("user_id = ?", @student)
  end
end
