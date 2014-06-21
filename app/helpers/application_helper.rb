module ApplicationHelper
  def accessible_courses
    if can? :manage, Course
      active_courses
    else
      current_user.courses
    end
  end

  def link_to_course(course)
    full_title = "#{course.title} (#{course.start_date} - #{course.end_date})"
    if can?(:manage, course) and !current_user.courses.include?(course)
      link_to full_title, main_app.course_enrollments_path(course), method: :post
    else
      link_to full_title, main_app.course_path(course)
    end
  end

  def current_if(*args)
    args.any?{ |arg| currently_in?(arg) } ? "current" : ""
  end

  def currently_in?(arg)
    params[:controller] == arg
  end

  def self_reports_due
    return @self_reports_due if @self_reports_due.present?
    return 0 unless current_course

    end_date = [Date.today, current_course.end_date].min
    begin_date = current_course.start_date

    expected = (end_date - begin_date).to_i
    actual = current_user.self_reports.where(date: begin_date..end_date).count

    @self_reports_due = expected - actual
  end
end
