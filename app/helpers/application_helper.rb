module ApplicationHelper
  def avatar_for(current_user)
    current_user.photo.url || current_user.avatar_url
  end

  def current_if(arg)
    currently_in?(arg) ? "current" : ""
  end

  def currently_in?(arg)
    if arg.is_a? Regexp
      arg =~ request.fullpath
    else
      params[:controller] == arg
    end
  end
end
