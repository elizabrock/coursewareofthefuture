class AssignmentsController < ApplicationController
  expose(:assignment_options){ Material.ls(current_user.octoclient, current_course.source_repository, "exercises") }
  expose(:assignments){ current_user.instructor? ? current_course.assignments : current_course.assignments.published }
  expose(:assignment, attributes: :assignment_params)

  before_filter :require_instructor!, except: [:index, :show]

  def new
    assignment.populate_from_github(params[:assignment_source], current_user.octoclient)
  end

  def create
    if assignment.save
      redirect_to course_assignment_path(current_course, assignment), notice: "Your assignment has been updated."
    else
      flash.alert = "Your assignment could not be updated."
      render :new
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:title, :summary, :published, milestones_attributes: [:id, :title, :instructions, :deadline])
  end
end
