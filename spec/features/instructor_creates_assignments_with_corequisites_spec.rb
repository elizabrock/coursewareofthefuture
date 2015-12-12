require 'rails_helper'

feature "Instructor creates assignment with corequisites", vcr: true do
  scenario "Happy Path, creating milestones with corequisites" do
    course = Fabricate(:course,
                        title: "Cohort 4",
                        start_date: "2013/02/28", end_date: "2013/06/01")

    Fabricate(:published_assignment, title: "Capstone", course: course)
    signin_as(:instructor, courses: [course])
    visit new_course_assignment_path(course)

    select "Ruby Koans", from: "Assignment"
    click_button "Set Milestones"

    fill_in "Start Date", with: "2013/03/20"
    within_fieldset("Strings Milestone") do
      fill_in "Deadline", with: "2013/03/24"
      within("fieldset.corequisites") do
        page.should have_checkboxes(material_titles)
      end
      check "Garbage Collection"
    end
    within_fieldset("Objects Milestone") do
      fill_in "Deadline", with: "2013/04/28"
      within("fieldset.corequisites") do
        page.should have_checkboxes(material_titles)
      end
      check "Logic"
    end
    within_fieldset("Triangles Milestone") do
      fill_in "Deadline", with: "2013/05/28"
      within("fieldset.corequisites") do
        page.should have_checkboxes(material_titles)
      end
      check "Logic"
      check "Truth Tables"
    end

    click_button "Save Assignment"
    page.should have_content "Your assignment has been updated."

    click_link "Assignments"
    click_link "Ruby Koans"

    page.should have_content("starts 3/20")
    within(milestone("Strings")) do
      page.should have_content("due 3/24")
      page.should_not have_content("Logic")
      page.should have_content("Garbage Collection")
      page.should_not have_content("Truth Tables")
      page.should_not have_content("Basic Control Structures")
    end
    within(milestone("Objects")) do
      page.should have_content("due 4/28")
      page.should have_content("Logic")
      page.should_not have_content("Garbage Collection")
      page.should_not have_content("Truth Tables")
      page.should_not have_content("Basic Control Structures")
    end
    within(milestone("Triangles")) do
      page.should have_content("due 5/28")
      page.should have_content("Logic")
      page.should_not have_content("Garbage Collection")
      page.should have_content("Truth Tables")
      page.should_not have_content("Basic Control Structures")
    end
  end
end
