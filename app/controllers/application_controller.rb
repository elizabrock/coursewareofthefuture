class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  before_filter :authenticate!, unless: :devise_controller?

  expose(:active_courses){ Course.active_or_future }
  expose(:current_course){ Course.find_by_id(params[:course_id]) }

  protected

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
end
