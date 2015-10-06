class UsersController < ApplicationController
  expose(:instructors){ User.instructors }
  expose(:observers){ User.observers }
  expose(:students){ User.students }
  expose(:user)
  expose(:self_reports, ancestor: :user)
  expose(:self_report)

  skip_before_filter :require_profile!, only: :edit

  def index
    render "enrollments/index"
  end

  def update
    user_params = params.require(:user).permit(:name, :email, :phone, :goals, :background, :photo_confirmed, :photo)
    if current_user.update_attributes(user_params)
      flash[:notice] = "Your profile has been updated."
      redirect_to current_user
    else
      flash.alert = "Your profile could not be updated."
      render :edit
    end
  end

  def observify
    if can?(:observify, user)
      user.become_observer!
      redirect_to users_path, notice: "#{user.name} is now an observer."
    else
      redirect_to users_path, alert: "You are not authorized."
    end
  end

  def instructify
    if can?(:instructify, user)
      user.become_instructor!
      redirect_to users_path, notice: "#{user.name} is now an instructor."
    else
      redirect_to users_path, alert: "You are not authorized."
    end
  end
end
