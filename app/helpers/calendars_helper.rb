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
    # f = render_to_string(:partial => "/app/views/shared/_self_report_form.haml", :layout => false)
    # (s<<f).html_safe
    s<<render(partial: "self_report_form").to_s
  end
end