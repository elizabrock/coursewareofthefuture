class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  before_filter :authenticate!, unless: :devise_controller?
  before_filter :set_student_shadowing
  before_filter :require_profile!

  expose(:active_courses){ Course.active_or_future }
  expose(:current_course){ current_user.try(:courses).try(:find_by_id, params[:course_id]) }
  expose(:enrollment_eligible_courses){ active_courses - current_user.courses }
  expose(:material_fullpaths) do
    Material.root(current_user.octoclient, current_course.source_repository, /^exercises/).
      descendants.
      find_all{ |m| m.leaf? }.
      map(&:fullpath)
  end

  protected
  def authenticate!
    unless user_signed_in?
      redirect_to root_path, alert: "You need to sign in or sign up before continuing."
    end
  end

  def require_instructor!
    unless user_signed_in? and current_user.instructor? and !current_user.viewing_as_student?
      redirect_to root_path, alert: "You must be authenticated as an instructor to access this material."
    end
  end

  def require_profile!
    return unless user_signed_in?
    return unless request.method == "GET"
    unless current_user.has_confirmed_photo?
      flash.keep
      flash.alert = "You must confirm your profile image in order to continue."
      redirect_to edit_user_path(current_user)
    end
  end

  def set_student_shadowing
    return unless current_user.try(:instructor?)
    current_user.viewing_as_student = session[:as_student]
  end
end
