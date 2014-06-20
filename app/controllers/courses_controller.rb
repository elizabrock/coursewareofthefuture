class CoursesController < ApplicationController
  expose(:course, attributes: :course_params)
  expose(:current_course){ current_user.courses.find_by_id params[:id] }

  before_filter :require_instructor!, except: [:show]

  def create
    if course.save
      current_user.courses << course
      redirect_to course_path(course), notice: "Course successfully created."
    else
      flash.alert = "Course couldn't be created."
      render :new
    end
  end

  def edit
  end

  def update
    if course.update_attributes(course_params)
      redirect_to course_path(course), notice: "Course successfully updated."
    else
      flash.alert = "Course couldn't be updated."
      render :index
    end  
  end

  private

  def course_params
    params.require(:course).permit(:title, :syllabus, :start_date, :end_date, :source_repository)
  end

end
