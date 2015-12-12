require 'calendar_helper'

module EventsHelper
  def format_calendar_date(d, entries, course)
    outside_of_course = (d < course.start_date or d > course.end_date)
    css_class = outside_of_course ? "outside-of-class" : "in-class"
    id = d.to_s
    # See https://github.com/topfunky/calendar_helper for format explanation:

    output = []
    unless outside_of_course
      output << content_tag("h5", d.mday.to_s, class: "day-header")

      entries[d].each do |e|
        title = e[:summary]
        label_class = e[:class]
        output << content_tag("span", title, class: "label radius #{label_class}")
      end
      output << self_report(d, course)
    end

    [ output.join, { class: css_class, id: id } ]
  end

  def entries_for_course(course)
    days = Hash.new{|hash, key| hash[key] = []}
    populate_special_events(days, course)
    populate_events(days, course)
    populate_assignments(days, course)
    populate_materials(days, course)
    populate_quizzes(days, course)
    days
  end

  private

  def milestone_link(milestone, milestone_description)
    link = milestone.assignment.published? ? course_assignment_path(course, milestone.assignment) : edit_course_assignment_path(course, milestone.assignment)
    class_text = milestone.milestone_submissions[0] ? "secondary" : "alert"
    { summary: link_to(milestone_description, link), class: class_text }
  end

  def populate_assignments(days, course)
    assignments = course.assignments.find_all{ |a| can?(:view, a) && (a.published? or a.publishable?) }
    assignments.each do |assignment|
      milestones = assignment.milestones.to_a
      start_date = assignment.start_date
      days[start_date] << milestone_link(milestones.first, "#{assignment.title} Starts")
      milestones.each do |milestone|
        (start_date + 1).upto(milestone.deadline - 1) do |work_date|
          days[work_date] << milestone_link(milestone, "Work on #{milestone.assignment.title}: #{milestone.title}")
        end
        days[milestone.deadline] << milestone_link(milestone, "#{milestone.assignment.title}: #{milestone.title} Due")
        start_date = milestone.deadline
      end
    end
  end

  def populate_events(days, course)
    course.events.each do |event|
      days[event.date] << { summary: event.summary, class: "secondary"}
    end
  end

  def populate_materials(days, course)
    course.covered_materials.each do |covered_material|
      material_description = "#{covered_material.formatted_title} Covered"
      class_text = ReadMaterial.where(material_fullpath: covered_material.material_fullpath)[0] ? "secondary" : "primary"
      read_class = read_materials_fullpaths.include?(covered_material.fullpath) ? "fi-check" : "fi-asterisk"

      days[covered_material.covered_on] << { summary: link_to(material_description, material_path_for(covered_material)), class: "#{class_text} read-status #{read_class}"}
    end
  end

  def populate_quizzes(days, course)
    quizzes = course.quizzes.find_all{|q| can?(:view, q) }
    quizzes.collect do |quiz|
      quiz_description = "#{quiz.title} Due"
      link = quiz.published? ? edit_course_quiz_submission_path(course, quiz) : edit_course_quiz_path(course, quiz)
      class_text = quiz.quiz_submissions[0] ? "secondary" : "alert"
      days[quiz.deadline] << { summary: link_to(quiz_description, link), class: class_text}
    end
  end

  def populate_special_events(days, course)
    days[Date.today] << { summary: "Today", class: "success"}
    days[course.start_date] << { summary: "First Day of Class", class: "secondary"}
    days[course.end_date] << { summary: "Last Day of Class", class: "secondary"}
  end

  def self_report(d, course)
    return "" if d > Date.today.end_of_day

    self_report = current_user.self_reports.find{ |sr| sr.date == d }
    self_report ||= SelfReport.new(date: d)
    render self_report
  end
end
