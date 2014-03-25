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
    s << add_form(d, course)
  end

  def add_form(d, course)
    @self_report = SelfReport.find_by(date: d)
    if @self_report
      render(partial: "completed_self_report", locals: { date: d}).to_s
    elsif d < Time.now.midnight.to_date
      @self_report = SelfReport.new
      render(partial: "self_report_form", locals: { date: d }).to_s
    else
      render(partial: "today_and_future", locals: { date: d}).to_s
    end
  end
end