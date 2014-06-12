module ApplicationHelper
  def accessible_courses
    if can? :manage, Course
      active_courses
    else
      current_user.courses
    end
  end

  def link_to_course(course)
    if can?(:manage, course) and !current_user.courses.include?(course)
      link_to course.title, main_app.course_enrollments_path(course), method: :post
    else
      link_to course.title, main_app.course_path(course)
    end
  end

  def current_if(*args)
    args.any?{ |arg| currently_in?(arg) } ? "current" : ""
  end

  def currently_in?(arg)
    if arg.is_a? Regexp
      arg =~ request.fullpath
    else
      params[:controller] == arg
    end
  end

  def self_reports_due
    return 0 unless current_course
    current_day = Date.today
    if current_day >= current_course.end_date
      current_day = current_course.end_date
    end
    expected = (current_day - current_course.start_date).to_i
    if current_day == current_course.end_date
      self_reports_remaining = expected - current_user.self_reports.count
    else
      self_reports_remaining = expected - current_user.self_reports.count + 1
    end
  end
end
