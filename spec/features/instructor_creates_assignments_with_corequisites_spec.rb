require 'rails_helper'

feature "Instructor creates assignment with corequisites", vcr: true do
  scenario "Happy Path, automatically generated corequisites" do
    course = Fabricate(:course, start_date: "2013/02/28", end_date: "2013/06/01")
    signin_as(:instructor, courses: [course])
    visit new_course_assignment_path(course)

    select "Cheers", from: "Assignment"
    click_button "Set Milestones"

    fill_in "Start Date", with: "2013/03/20"
    within_fieldset("Milestone 1") do
      fill_in "Deadline", with: "2013/03/24"
      within("fieldset.corequisites") do
        page.should have_checkboxes(material_titles)
      end
      find_field("Life Skills").should be_checked
      find_field("Nyan Cat").should be_checked
      check "Garbage Collection"
    end
    within_fieldset("Milestone 2") do
      fill_in "Deadline", with: "2013/04/28"
      within("fieldset.corequisites") do
        page.should have_checkboxes(material_titles)
      end
      find_field("Basic Control Structures").should be_checked
      check "Logic"
    end

    click_button "Save Assignment"
    page.should have_content "Your assignment has been updated."

    click_link "Assignments"
    click_link "Cheers"

    page.should have_content("starts 3/20")
    within(milestone("Milestone 1")) do
      page.should have_content("due 3/24")
      page.should have_content("Life Skills")
      page.should have_content("Nyan Cat")
      page.should have_content("Garbage Collection")
      page.should_not have_content("Logic")
      page.should_not have_content("Basic Control Structures")
    end

    within(milestone("Milestone 2")) do
      page.should have_content("due 4/28")
      page.should_not have_content("Life Skills")
      page.should_not have_content("Nyan Cat")
      page.should_not have_content("Garbage Collection")
      page.should have_content("Logic")
      page.should have_content("Basic Control Structures")
    end

    page.should_not have_content("requires: life-skills, nyan-cat")
    page.should_not have_content("requires: basic-control-structures")
  end

  scenario "Sad Path, automatically generated corequisites ignores unfindable corequisites" do
    course = Fabricate(:course, start_date: "2013/02/28", end_date: "2013/06/01")
    signin_as(:instructor, courses: [course])
    visit new_course_assignment_path(course)

    select "Half Baked Assignment", from: "Assignment"
    click_button "Set Milestones"

    fill_in "Start Date", with: "2013/03/20"
    within_fieldset("Milestone 1") do
      fill_in "Deadline", with: "2013/03/24"
      within("fieldset.corequisites") do
        page.should have_checkboxes(material_titles)
      end
      find_field("Life Skills").should be_checked
    end
    click_button "Save Assignment"
    page.should have_content "Your assignment has been updated."

    click_link "Assignments"
    click_link "Half-Baked Assignment"

    page.should have_content("starts 3/20")
    within(milestone("Milestone 1")) do
      page.should have_content("due 3/24")
      page.should have_content("Life Skills")
    end

    page.should_not have_content("> requires: life-skills, foo")
  end

  scenario "Happy Path, manually creating milestones with corequisites" do
    course = Fabricate(:course, start_date: "2013/02/28", end_date: "2013/06/01")
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
