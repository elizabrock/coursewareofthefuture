class AssignmentsController < ApplicationController
  expose(:assignment_options){ Material.list(current_user.octoclient, current_course.source_repository, "exercises") }
  expose(:assignments){ current_course.assignments }
  expose(:assignment, attributes: :assignment_params)
  expose(:materials){ Material.root(current_user.octoclient, current_course.source_repository, /^exercises/).descendants }


  expose(:viewable_assignments){ assignments.to_a.delete_if{|a| cannot? :view, a }.sort_by{|a| a.last_deadline || 1.year.from_now } }
  expose(:published_quizzes){ current_course.quizzes.published }
  expose(:unpublished_quizzes){ current_course.quizzes.unpublished }

  before_filter :require_instructor!, except: [:index, :show]

  def new
    source = params[:assignment_source]
    begin
      assignment.populate_from_github(source, current_user.octoclient)
    rescue Octokit::NotFound
      redirect_to select_course_assignments_path(current_course), alert: "Could not retrieve instructions.md in #{source}.  Please confirm that the instructions.md is ready and then try again."
    end
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
    params.require(:assignment).permit(:title, :summary, :published,
                                       prerequisites_attributes: [:id, :material_fullpath],
                                       milestones_attributes: [:id, :title, :instructions, :deadline])
  end
end
