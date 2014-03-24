class EnrollmentsController < ApplicationController
  expose(:instructors){ User.instructors }
  expose(:students){ current_course.users.students }
end
