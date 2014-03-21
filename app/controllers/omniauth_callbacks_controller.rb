class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    student = Student.find_or_create_for_github_oauth(request.env["omniauth.auth"])
    sign_in_and_redirect student, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
  end
end
