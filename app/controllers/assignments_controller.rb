class AssignmentsController < ApplicationController
  expose(:assignment_options){ Material.list(current_user.octoclient, current_course.source_repository, "exercises") }
  expose(:assignments){ current_course.assignments }
  expose(:assignment, attributes: :assignment_params)

  expose(:prerequisite_fullpaths){ assignment.prerequisites.map(&:fullpath) }
  expose(:materials) do
    Material.root(current_user.octoclient, current_course.source_repository, /^exercises/).
      descendants.
      find_all{ |m| m.leaf? }
  end
  expose(:material_fullpaths) do
    Material.root(current_user.octoclient, current_course.source_repository, /^exercises/).
      descendants.
      find_all{ |m| m.leaf? }.
      map(&:fullpath)
  end

  expose(:viewable_assignments){ assignments.to_a.delete_if{|a| cannot? :view, a }.sort_by{|a| a.last_deadline || 1.year.from_now } }
  expose(:published_quizzes){ current_course.quizzes.published }
  expose(:unpublished_quizzes){ current_course.quizzes.unpublished }

  before_filter :require_instructor!, except: [:index, :show]

  def create
    assignment.assign_attributes(assignment_params)
    begin
      assignment.populate_from_github(current_user.octoclient)
      assignment.save!
      redirect_to edit_course_assignment_path(current_course, assignment)
    rescue Octokit::NotFound
      redirect_to new_course_assignment_path(current_course), alert: "Could not retrieve instructions.md in #{assignment.source}.  Please confirm that the instructions.md is ready and then try again."
    end
  end

  def update
    (params[:material_fullpaths] || []).each do |material_fullpath|
      assignment.prerequisites.build(material_fullpath: material_fullpath)
    end
    if assignment.save
      if assignment.published?
        redirect_to course_assignment_path(current_course, assignment), notice: "Your assignment has been published."
      else
        redirect_to edit_course_assignment_path(current_course, assignment), notice: "Your assignment has been updated."
      end
    else
      attempted_status = assignment.published ? "published" : "updated"
      flash.alert = "Your assignment could not be #{attempted_status}."
      render :edit
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:title, :summary, :published, :source,
                                       milestones_attributes: [:id, :title, :instructions, :deadline])
  end
end
