require 'rails_helper'

feature "Instructor creates assignment with prerequisites", vcr: true, js: true do

  scenario "Happy Path, creating an assignment with prerequisites" do
    Timecop.travel(Time.new(2013, 03, 01)) do
      course = Fabricate(:course,
                         title: "Cohort 4",
                         start_date: "2013/02/28", end_date: "2013/06/01")

      Fabricate(:assignment, title: "Capstone", course: course)
      signin_as(:instructor, courses: [course])
      visit select_course_assignments_path(course)

      select "Ruby Koans", from: "Assignment"
      click_button "Set Milestones"
      save_and_open_page
      page.should have_checkboxes(materials_list)
      check "Logic"
      check "Garbage Collection"

      within_fieldset("Strings Milestone") do
        fill_in "Deadline", with: "2013/03/24"
      end
      within_fieldset("Objects Milestone") do
        fill_in "Deadline", with: "2013/04/28"
      end
      within_fieldset("Triangles Milestone") do
        fill_in "Deadline", with: "2013/05/28"
      end

      click_button "Save Assignment"
      page.should have_content "Your assignment has been updated."

      click_link "Assignments"
      page.should have_list ["Capstone", "Ruby Koans"]

      click_link "Ruby Koans"

      within(".prerequisites") do
        page.should have_content("Logic")
        page.should have_content("Garbage Collection")
        page.should_not have_content("Basic Control Structures")
      end
    end
  end
end
