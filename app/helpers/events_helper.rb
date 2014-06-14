module EventsHelper
  def format_calendar_date(d, course)
    outside_of_course = (d < course.start_date or d > course.end_date)
    css_class = "outside-of-class" if outside_of_course

    header = content_tag("h5", d.mday.to_s, class: css_class)
    return header if outside_of_course

    events = []
    events << { summary: "Today", class: "success"} if d == Date.today
    events << { summary: "First Day of Class", class: ""} if d == course.start_date
    events << { summary: "Last Day of Class", class: ""} if d == course.end_date
    events << populate_events(d, course)
    events << populate_materials(d, course)
    events << populate_milestones(d, course)
    events << populate_quizzes(d, course)

    output = header
    events.flatten.each do |e|
      title = e[:summary]
      css_class = e[:class]
      output << content_tag("span", title, class: "label radius #{css_class}")
    end
    output << self_report_form(d, course)
    output
  end

  private

  def self_report_form(d, course)
    return "" if d > Date.today.end_of_day

    if self_report = current_user.self_reports.find{ |sr| sr.date == d }
      render(partial: "self_reports/completed_self_report", locals: { self_report: self_report, date: d}).to_s
    else
      self_report = SelfReport.new(date: d)
      render(partial: "self_reports/self_report_form", locals: { self_report: self_report, date: d }).to_s
    end
  end

  def populate_events(d, course)
    events = course.events.find_all{|e| e.date.to_date == d }
    events.collect{ |event| { summary: event.summary, class: ""} }
  end

  def populate_materials(d, course)
    covered_materials = course.covered_materials.find_all{|cm| cm.covered_on.to_date == d }
    covered_materials.collect do |covered_material|
      material_description = "#{covered_material.formatted_title} Covered"
      { summary: material_description, class: "secondary"}
    end
  end

  def populate_milestones(d, course)
    milestones = course.milestones.find_all{|m| m.deadline.to_date == d and m.assignment.published? }
    milestones.collect do |milestone|
      milestone_description = "#{milestone.assignment.title}: #{milestone.title} Due"
      { summary: milestone_description, class: "alert"}
    end
  end

  def populate_quizzes(d, course)
    quizzes = course.quizzes.published.find_all{|q| q.deadline.to_date == d }
    quizzes.collect do |quiz|
      quiz_description = "#{quiz.title} Due"
      { summary: quiz_description, class: "alert"}
    end
  end
end
