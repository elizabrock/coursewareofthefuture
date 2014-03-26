class HomeController < ApplicationController
  skip_before_filter :authenticate!

  def index
    return unless current_user
    if current_user.instructor?
      if Course.count == 1
        redirect_to Course.first
      else
        redirect_to courses_path
      end
    elsif current_user.courses.empty?
      redirect_to new_enrollment_path
    else
      redirect_to course_path(current_user.courses.first)
    end
  end
end
