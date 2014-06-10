require 'rails_helper'

feature "Assignments quizzes and materials appear on calendar" do

  let!(:course){ Fabricate(:course, title: "Cohort N", start_date: "2014/01/01", end_date: "2014/02/01") }

  background do
    signin_as :student, courses: [course]
  end

  scenario "Assignments" do
    unpublished = Fabricate(:unpublished_assignment, title: "Unpublished Assignment", course: course)
    Fabricate(:milestone, title: "Pt. n", deadline: "2014/01/03", assignment: unpublished)

    published = Fabricate(:published_assignment, title: "Koans", course: course)
    Fabricate(:milestone, title: "Pt. 1", deadline: "2014/01/02", assignment: published)
    Fabricate(:milestone, title: "Pt. 2", deadline: "2014/01/04", assignment: published)

    visit root_path
    click_link "Course Calendar"
    page.should have_calendar_entry("2014-01-02", text: "Koans: Pt. 1 Due")
    page.should have_calendar_entry("2014-01-04", text: "Koans: Pt. 2 Due")
    page.should_not have_content "Unpublished Assignment"
    page.should_not have_content "Pt. n"
  end

  scenario "Quizzes" do
    Fabricate(:quiz, title: "Baseline Knowledge", deadline: "2014/01/01", course: course)
    Fabricate(:quiz, title: "Midpoint Checkin", deadline: "2014/01/15", course: course)
    visit root_path
    click_link "Course Calendar"
    page.should have_calendar_entry("2014-01-01", text: "Baseline Knowledge Due")
    page.should have_calendar_entry("2014-01-15", text: "Midpoint Checkin Due")
  end

  scenario "Covered Materials" do
    Fabricate(:covered_material,
              material_fullpath: "materials/computer-science/logic/logic.md",
              covered_on: "2014/01/15", course: course)
    Fabricate(:covered_material,
              material_fullpath: "materials/computer-science/logic/set_theory.md",
              covered_on: "2014/01/20", course: course)
    visit root_path
    click_link "Course Calendar"

    page.should have_calendar_entry("2014-01-15", text: "Logic")
    page.should have_calendar_entry("2014-01-20", text: "Set Theory")
  end
end
