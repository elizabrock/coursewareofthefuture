class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate!

  expose(:course){ Course.active }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << [:phone, :name]
  end

  def authenticate!
    unless instructor_signed_in?
      authenticate_student!
    end
  end
end
