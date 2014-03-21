class StudentProfilesController < ApplicationController
  expose(:students)
  expose(:student)

  def update
    student_params = params.require(:student).permit(:name, :email, :phone, :goals)
    if current_student.update_attributes(student_params)
      redirect_to student_profile_path(current_student), notice: "Your profile has been updated."
    else
      render :edit
    end
  end

end
