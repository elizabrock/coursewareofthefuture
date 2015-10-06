module EventsHelper
  def format_calendar_date(d, course)
    outside_of_course = (d < course.start_date or d > course.end_date)
    css_class = outside_of_course ? "outside-of-class" : "in-class"
    id = d.to_s

    output = ""
    unless outside_of_course
      events = []
      events << { summary: "Today", class: "success"} if d == Date.today
      events << { summary: "First Day of Class", class: "secondary"} if d == course.start_date
      events << { summary: "Last Day of Class", class: "secondary"} if d == course.end_date
      events << populate_events(d, course)
      events << populate_materials(d, course)
      events << populate_milestones(d, course)
      events << populate_quizzes(d, course)

      output << content_tag("h5", d.mday.to_s, class: "day-header")
      events.flatten.each do |e|
        title = e[:summary]
        label_class = e[:class]
        output << content_tag("span", title, class: "label radius #{label_class}")
      end

      output << self_report(d, course) unless outside_of_course
    end

    # See https://github.com/topfunky/calendar_helper for format explanation:
    [ output, { class: css_class, id: id } ]
  end

  private

  def self_report(d, course)
    return "" if d > Date.today.end_of_day

    self_report = current_user.self_reports.find{ |sr| sr.date == d }
    self_report ||= SelfReport.new(date: d)
    render self_report
  end

  def populate_events(d, course)
    events = course.events.find_all{|e| e.date == d }
    events.collect{ |event| { summary: event.summary, class: "secondary"} }
  end

  def populate_materials(d, course)
    covered_materials = course.covered_materials.find_all{|cm| cm.covered_on == d }
    covered_materials.collect do |covered_material|
      material_description = "#{covered_material.formatted_title} Covered"
      read_class = read_materials_fullpaths.include?(covered_material.fullpath) ? "fi-check" : "fi-asterisk"

      { summary: link_to(material_description, material_path_for(covered_material)), class: "secondary read-status #{read_class}"}
    end
  end

  def populate_milestones(d, course)
    milestones = course.milestones.find_all{|m| m.deadline == d and can?(:view, m.assignment) }
    milestones.collect do |milestone|
      milestone_description = "#{milestone.assignment.title}: #{milestone.title} Due"
      link = milestone.assignment.published? ? course_assignment_path(course, milestone.assignment) : edit_course_assignment_path(course, milestone.assignment)
      { summary: link_to(milestone_description, link), class: "secondary"}
    end
  end

  def populate_quizzes(d, course)
    quizzes = course.quizzes.find_all{|q| q.deadline == d && can?(:view, q) }
    quizzes.collect do |quiz|
      quiz_description = "#{quiz.title} Due"
      link = quiz.published? ? edit_course_quiz_submission_path(course, quiz) : edit_course_quiz_path(course, quiz)
      { summary: link_to(quiz_description, link), class: "secondary"}
    end
  end
end
