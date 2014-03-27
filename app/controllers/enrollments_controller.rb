class EnrollmentsController < ApplicationController
  expose(:instructors){ User.instructors }
  expose(:students){ current_course.users.students }
  expose(:enrollment){ current_course.enrollments.build(user: current_user) }
  expose(:enrollment_eligible_courses){ active_courses - current_user.courses }

  def create
    enrollment.save!
    redirect_to current_course, notice: "You are now enrolled in #{current_course.title}"
  end
end
