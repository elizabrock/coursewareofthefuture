module CalendarsHelper
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
    s << render(partial: "self_report_form", locals: { date: d }).to_s
  end
end
