class UsersController < ApplicationController
  expose(:instructors){ User.instructors }
  expose(:students){ User.students }
  expose(:user)

  skip_before_filter :require_confirmed_profile_image!, only: :confirm_image

  def index
    render "enrollments/index"
  end

  def update
    user_params = params.require(:user).permit(:name, :email, :phone, :goals, :background, :avatar_url, :avatar_confirmed, :photo)
    if current_user.update_attributes(user_params)
      redirect_to current_user, notice: "Your profile has been updated."
    else
      render :edit
    end
  end

  def instructify
    if current_user.instructor?
      user.update_attribute(:instructor, true)
      redirect_to users_path, notice: "#{user.name} is now an instructor."
    else
      redirect_to users_path, alert: "You are not authorized."
    end
  end
end
