require 'rails_helper'

feature "Instructor creates assignment with corequisites", vcr: true do
  scenario "Happy Path, creating milestones with corequisites" do
    course = Fabricate(:course,
                        title: "Cohort 4",
                        start_date: "2013/02/28", end_date: "2013/06/01")

    Fabricate(:assignment, title: "Capstone", course: course)
    signin_as(:instructor, courses: [course])
    visit new_course_assignment_path(course)

    select "Ruby Koans", from: "Assignment"
    click_button "Set Milestones"

    within_fieldset("Strings Milestone") do
      fill_in "Deadline", with: "2013/03/24"
      within("fieldset.corequisites") do
        expect(page).to have_checkboxes(material_titles)
      end
      check "Garbage Collection"
    end
    within_fieldset("Objects Milestone") do
      fill_in "Deadline", with: "2013/04/28"
      within("fieldset.corequisites") do
        expect(page).to have_checkboxes(material_titles)
      end
      check "Logic"
    end
    within_fieldset("Triangles Milestone") do
      fill_in "Deadline", with: "2013/05/28"
      within("fieldset.corequisites") do
        expect(page).to have_checkboxes(material_titles)
      end
      check "Logic"
      check "Truth Tables"
    end

    click_button "Save Assignment"
    expect(page).to have_content "Your assignment has been updated."

    click_link "Assignments"
    click_link "Ruby Koans"

    within(milestone("Strings")) do
      expect(page).not_to have_content("Logic")
      expect(page).to have_content("Garbage Collection")
      expect(page).not_to have_content("Truth Tables")
      expect(page).not_to have_content("Basic Control Structures")
    end
    within(milestone("Objects")) do
      expect(page).to have_content("Logic")
      expect(page).not_to have_content("Garbage Collection")
      expect(page).not_to have_content("Truth Tables")
      expect(page).not_to have_content("Basic Control Structures")
    end
    within(milestone("Triangles")) do
      expect(page).to have_content("Logic")
      expect(page).not_to have_content("Garbage Collection")
      expect(page).to have_content("Truth Tables")
      expect(page).not_to have_content("Basic Control Structures")
    end
  end
end
