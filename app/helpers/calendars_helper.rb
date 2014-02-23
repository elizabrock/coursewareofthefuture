module CalendarsHelper
  def format_calendar_date(d, course)
    if d == course.start_date
      "#{d.mday}<br />First Day of Class".html_safe
    elsif d == course.end_date
      "#{d.mday}<br />Last Day of Class".html_safe
    elsif event = events.find{|e| e.date == d }
      "#{d.mday}<br />#{event.summary}".html_safe
    else
      d.mday
    end
  end
end
