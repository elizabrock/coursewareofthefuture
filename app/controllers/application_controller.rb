class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate!, unless: :devise_controller?

  expose(:course){ Course.active }

  protected

  def authenticate!
    unless user_signed_in?
      redirect_to root_path, alert: "You need to sign in or sign up before continuing."
    end
  end
end
