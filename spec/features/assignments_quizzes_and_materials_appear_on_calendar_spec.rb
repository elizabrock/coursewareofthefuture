require 'rails_helper'

feature "Assignments quizzes and materials appear on calendar", vcr: true do

  let!(:course){ Fabricate(:course, title: "Cohort N", start_date: "2014/01/01", end_date: "2014/02/01") }

  scenario "Assignments" do
    signin_as :student, courses: [course], github_username: "elizabrock"

    unpublished = Fabricate(:unpublished_assignment, title: "Unpublished Assignment", course: course)
    Fabricate(:milestone, title: "Pt. n", deadline: "2014/01/03", assignment: unpublished)

    published = Fabricate(:published_assignment, title: "Koans", course: course)
    Fabricate(:milestone, title: "Pt. 1", deadline: "2014/01/02", assignment: published)
    Fabricate(:milestone, title: "Pt. 2", deadline: "2014/01/04", assignment: published)

    visit course_calendar_path(course)
    expect(page).to have_calendar_entry("1/02", text: "Koans: Pt. 1 Due")
    expect(page).to have_calendar_entry("1/04", text: "Koans: Pt. 2 Due")
    expect(page).to_not have_content "Unpublished Assignment"
    expect(page).to_not have_content "Pt. n"

    click_link "Koans: Pt. 1 Due"
    expect(current_path).to eql course_assignment_path(course, published)
  end

  scenario "Assignments, as instructor" do
    signin_as :instructor, courses: [course]

    unpublished = Fabricate(:unpublished_assignment, title: "Unpublished Assignment", course: course)
    Fabricate(:milestone, title: "Pt. n", deadline: "2014/01/03", assignment: unpublished)

    published = Fabricate(:published_assignment, title: "Koans", course: course)
    Fabricate(:milestone, title: "Pt. 1", deadline: "2014/01/02", assignment: published)
    Fabricate(:milestone, title: "Pt. 2", deadline: "2014/01/04", assignment: published)

    visit course_calendar_path(course)
    expect(page).to have_calendar_entry("1/02", text: "Koans: Pt. 1 Due")
    expect(page).to have_calendar_entry("1/04", text: "Koans: Pt. 2 Due")
    expect(page).to have_calendar_entry("1/03", text: "Unpublished Assignment: Pt. n Due")

    click_link "Unpublished Assignment: Pt. n Due"
    expect(current_path).to eql edit_course_assignment_path(course, unpublished)
  end

  scenario "Fix: Multiple milestones on a day" do
    signin_as :student, courses: [course]

    published = Fabricate(:published_assignment, title: "Koans", course: course)
    Fabricate(:milestone, title: "Pt. 1", deadline: "2014/01/02", assignment: published)
    Fabricate(:milestone, title: "Pt. 2", deadline: "2014/01/02", assignment: published)

    visit course_calendar_path(course)
    expect(page).to have_calendar_entry("1/02", text: "Koans: Pt. 1 Due")
    expect(page).to have_calendar_entry("1/02", text: "Koans: Pt. 2 Due")
  end

  scenario "Quizzes" do
    signin_as :student, courses: [course]

    Fabricate(:unpublished_quiz, title: "Unpublished Knowledge", deadline: "2014/01/02", course: course)
    Fabricate(:quiz, title: "Baseline Knowledge", deadline: "2014/01/01", course: course)
    midpoint_quiz = Fabricate(:quiz, title: "Midpoint Checkin", deadline: "2014/01/15", course: course)
    visit course_calendar_path(course)
    expect(page).to have_calendar_entry("1/01", text: "Baseline Knowledge Due")
    expect(page).to have_calendar_entry("1/15", text: "Midpoint Checkin Due")
    expect(page).to_not have_content("Unpublished Knowledge")

    click_link "Midpoint Checkin Due"
    expect(current_path).to eql edit_course_quiz_submission_path(course, midpoint_quiz)
  end

  scenario "Quizzes, as an instructor" do
    signin_as :instructor, courses: [course]

    unpublished_quiz = Fabricate(:unpublished_quiz, title: "Unpublished Knowledge", deadline: "2014/01/02", course: course)
    Fabricate(:quiz, title: "Baseline Knowledge", deadline: "2014/01/01", course: course)
    Fabricate(:quiz, title: "Midpoint Checkin", deadline: "2014/01/15", course: course)
    visit course_calendar_path(course)
    expect(page).to have_calendar_entry("1/01", text: "Baseline Knowledge Due")
    expect(page).to have_calendar_entry("1/02", text: "Unpublished Knowledge Due")
    expect(page).to have_calendar_entry("1/15", text: "Midpoint Checkin Due")

    click_link "Unpublished Knowledge Due"
    expect(current_path).to eql edit_course_quiz_path(course, unpublished_quiz)
  end

  scenario "Fix: Multiple quizzes on a day" do
    signin_as :student, courses: [course]

    Fabricate(:quiz, title: "Baseline Knowledge", deadline: "2014/01/01", course: course)
    Fabricate(:quiz, title: "Midpoint Checkin", deadline: "2014/01/01", course: course)
    visit course_calendar_path(course)
    expect(page).to have_calendar_entry("1/01", text: "Baseline Knowledge Due")
    expect(page).to have_calendar_entry("1/01", text: "Midpoint Checkin Due")
  end

  scenario "Covered Materials" do
    signin_as :student, courses: [course]

    logic = Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/logic.md",
              covered_on: "2014/01/15", course: course)
    Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/set_theory.md",
              covered_on: "2014/01/20", course: course)
    visit course_calendar_path(course)
    expect(page).to have_calendar_entry("1/15", text: "Logic")
    expect(page).to have_calendar_entry("1/20", text: "Set Theory")

    click_link "Logic"
    expect(current_path).to eql course_material_path(course, logic.material_fullpath).gsub("%2F","/")
  end

  scenario "Fix: multiple covered materials on a day" do
    signin_as :student, courses: [course]

    Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/logic.md",
              covered_on: "2014/01/15", course: course)
    Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/set_theory.md",
              covered_on: "2014/01/15", course: course)
    visit course_calendar_path(course)
    expect(page).to have_calendar_entry("1/15", text: "Logic")
    expect(page).to have_calendar_entry("1/15", text: "Set Theory")
  end
end
