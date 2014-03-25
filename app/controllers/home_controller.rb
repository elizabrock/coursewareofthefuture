class HomeController < ApplicationController
  skip_before_filter :authenticate!

  def index
    if current_user
      if current_user.instructor?
        redirect_to courses_path
      elsif current_user.courses.empty?
        redirect_to new_enrollment_path
      else
        redirect_to course_path(current_user.courses.first)
      end
    end
  end
end
