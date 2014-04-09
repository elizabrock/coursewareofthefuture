module EventsHelper
  def format_calendar_date(d, course)
    outside_of_course = (d < course.start_date or d > course.end_date)

    css_class = "outside-of-class" if outside_of_course
    header = content_tag("h5", d.mday.to_s, class: css_class)

    event_strings = []

    if d == Date.today
      event_strings << ["Today", "success"]
    end

    if d == course.start_date
      event_strings << ["First Day of Class", ""]
    end

    if d == course.end_date
      event_strings << ["Last Day of Class", ""]
    end

    if event = events.find{|e| e.date == d }
      event_strings << [event.summary, "alert"]
    end

    output = header
    event_strings.each do |information|
      output << content_tag("span", information[0], class: "label radius #{information[1]}")
    end
    unless outside_of_course
      output << add_form(d, course)
    end
    output
  end

  def add_form(d, course)
    return "" if d > Date.today.end_of_day
    if self_report = current_user.self_reports.find{ |sr| sr.date == d }
      render(partial: "self_reports/completed_self_report", locals: { self_report: self_report, date: d}).to_s
    else
      self_report = SelfReport.new(date: d)
      render(partial: "self_reports/self_report_form", locals: { self_report: self_report, date: d }).to_s
    end
  end
end
