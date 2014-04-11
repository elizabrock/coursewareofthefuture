class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  before_filter :authenticate!, unless: :devise_controller?
  before_filter :set_student_shadowing
  before_filter :require_confirmed_photo!

  expose(:active_courses){ Course.active_or_future }
  expose(:current_course){ current_user.try(:courses).try(:find_by_id, (params[:course_id] || params[:id])) }

  protected

  def set_student_shadowing
    return unless current_user.try(:instructor?)
    current_user.viewing_as_student = session[:as_student]
  end

  def require_instructor!
    unless user_signed_in? and current_user.instructor?
      redirect_to root_path, alert: "You must be authenticated as an instructor to access this material."
    end
  end

  def authenticate!
    unless user_signed_in?
      redirect_to root_path, alert: "You need to sign in or sign up before continuing."
    end
  end

  def require_confirmed_photo!
    return unless user_signed_in?
    return unless request.method == "GET"
    unless current_user.has_confirmed_photo?
      flash.keep
      redirect_to confirm_photo_user_path
    end
  end
end
