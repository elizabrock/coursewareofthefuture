class UsersController < ApplicationController
  expose(:instructors){ User.instructors }
  expose(:students){ User.students }
  expose(:user)

  skip_before_filter :require_confirmed_photo!, only: :confirm_photo

  def index
    render "enrollments/index"
  end

  def update_photo
    user_params = params.require(:user).permit(:remote_photo_url, :photo_confirmed, :photo)
    if current_user.update_attributes(user_params)
      redirect_to current_user, notice: "Your profile photo has been updated."
    else
      flash.alert = "Your profile photo could not be updated."
      render :confirm_photo
    end
  end

  def update
    user_params = params.require(:user).permit(:name, :email, :phone, :goals, :background, :remote_photo_url, :photo_confirmed, :photo)
    if current_user.update_attributes(user_params)
      redirect_to current_user, notice: "Your profile has been updated."
    else
      flash.alert = "Your profile could not be updated."
      render :edit
    end
  end

  def instructify
    if can?(:instructify, user)
      user.update_attribute(:instructor, true)
      redirect_to users_path, notice: "#{user.name} is now an instructor."
    else
      redirect_to users_path, alert: "You are not authorized."
    end
  end
end
