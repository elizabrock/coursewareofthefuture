class EnrollmentsController < ApplicationController
  expose(:instructors){ current_course.users.instructors }
  expose(:observers){ current_course.users.observers }
  expose(:students){ current_course.users.students }
  expose(:course)
  expose(:enrollment){ current_user.enrollments.build(course: course) }

  def create
    enrollment.save!
    redirect_to current_course, notice: "You are now enrolled in #{current_course.title}"
  end
end
