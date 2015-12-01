class CoursesController < ApplicationController
  expose(:course, attributes: :course_params)
  expose(:current_course){ current_user.courses.find_by_id(params[:id] || params[:course_id]) }
  expose(:first_of_each_month_of_course){ (current_course.start_date.change(day: 1)..current_course.end_date).select{ |d| d.day == 1 } }
  expose(:read_materials_fullpaths){ current_user.read_materials.map(&:material_fullpath) }

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

  def update
    if course.update_attributes(course_params)
      redirect_to courses_path, notice: "Course successfully updated."
    else
      flash.alert = "Course couldn't be updated."
      render :edit
    end
  end

  private

  def course_params
    params.require(:course).permit(:title, :start_date, :end_date, :source_repository)
  end

end
