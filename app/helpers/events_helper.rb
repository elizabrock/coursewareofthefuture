module EventsHelper
  def format_calendar_date(d, course)
    if d == course.start_date
      s = "#{d.mday}<br />First Day of Class"
    elsif d == course.end_date
      s = "#{d.mday}<br />Last Day of Class"
    elsif event = events.find{|e| e.date == d }
      s = "#{d.mday}<br />#{event.summary}"
    else
      s = d.mday.to_s
    end
    if d == Date.today
      s << "<br />Today"
    end
    s << add_form(d, course)
  end

  def add_form(d, course)
    self_report = SelfReport.find_by(date: d)
    if self_report
      render(partial: "self_reports/completed_self_report", locals: { self_report: self_report, date: d}).to_s
    elsif d < Time.now.midnight.to_date
      self_report = SelfReport.new(date: d)
      render(partial: "self_reports/self_report_form", locals: { self_report: self_report, date: d }).to_s
    else
      return ""
    end
  end
end
