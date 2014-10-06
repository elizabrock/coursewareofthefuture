require 'rails_helper'

feature "Instructor chooses assignments from github", vcr: true, js: true do

  scenario "Happy Path, creating an assignment" do
    course = Fabricate(:course,
                        title: "Cohort 4",
                        start_date: "2013/02/28", end_date: "2013/06/01")
    Fabricate(:assignment, title: "Capstone", course: course)

    instructor = Fabricate(:instructor, courses: [course])
    expect(instructor.photo_confirmed?).to be_truthy

    instructor2 = signin_as(instructor)
    expect(instructor2.id).to eql instructor.id
    expect(instructor2.photo_confirmed?).to be_truthy

    expect(Course.count).to eql 1

    visit root_path
    visit course_path(course)
    click_link "Assignments"
    click_link "New Assignment"
    expect(page).to have_options_for("Assignment",
                options: ["Cheers", "Ruby Koans", "Some Other Exercise", "Unfinished Exercise"])
    select "Ruby Koans", from: "Assignment"
    click_button "Set Milestones"
    expect(page).to have_content("publishing makes an assignment visible to students")
    expect(page).to have_content("Strings")
    expect(page).to have_content("Objects")
    expect(page).to have_content("Triangles")
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
    expect(page).to have_content "Your assignment has been updated."
    click_link "Assignments"
    expect(page).to have_list ["Ruby Koans", "Capstone"]
    click_link "Ruby Koans"
    expect(page).to have_content("Strings (due 3/24)")
    expect(page).to have_content("Objects (due 4/28)")
    expect(page).to have_content("Triangles (due 5/28)")
    within(milestone("Strings")) do
      expect(page).to have_content "Strings are basically arrays."
    end
    within(milestone("Objects")) do
      expect(page).to have_content "Objects are bloby."
    end
    within(milestone("Triangles")) do
      expect(page).to have_content "Triangles are shapes."
    end
  end

  scenario "Sad Path, creating an assignment" do
    course = Fabricate(:course,
      title: "Cohort 4",
      start_date: "2014/01/16",
      end_date: "2014/02/03")
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Assignments"
    click_link "New Assignment"
    select "Ruby Koans", from: "Assignment"
    click_button "Set Milestones"
    expect(page).to have_content("publishing makes an assignment visible to students")
    expect(page).to have_content("Strings")
    expect(page).to have_content("Objects")
    expect(page).to have_content("Triangles")
    within_fieldset("Strings Milestone") do
      fill_in "Deadline", with: "2013/03/24"
    end
    within_fieldset("Objects Milestone") do
      fill_in "Deadline", with: ""
    end
    within_fieldset("Triangles Milestone") do
      fill_in "Deadline", with: "2014/05/28"
    end
    click_button "Save Assignment"
    expect(page).to have_content "Your assignment could not be updated."
    within_fieldset("Triangles Milestone") do
      expect(page).to have_error_message("Must be in the course timeframe", on: "Deadline")
      expect(find_field("Deadline").value).to match /#{"2014/05/28"}/
      fill_in "Deadline", with: "2014/02/03"
    end
    within_fieldset("Strings Milestone") do
      expect(page).to have_error_message("Must be in the course timeframe", on: "Deadline")
      expect(find_field("Deadline").value).to match /#{"2013/03/24"}/
      fill_in "Deadline", with: "2014/02/01"
    end
    within_fieldset("Objects Milestone") do
      expect(page).not_to have_content("Must be set")
      expect(find_field("Deadline").value).to eql ""
    end
    click_button "Save Assignment"
    expect(page).to have_content "Your assignment has been updated."
    check "Published"
    click_button "Save Assignment"
    expect(page).to have_content "Your assignment could not be published."
    within_fieldset("Objects Milestone") do
      expect(page).to have_error_message("can't be blank", on: "Deadline")
      fill_in "Deadline", with: "2014/02/02"
    end
    within_fieldset("Triangles Milestone") do
      expect(find_field("Deadline").value).to match /#{"2014/02/03"}/
    end
    within_fieldset("Strings Milestone") do
      expect(find_field("Deadline").value).to match /#{"2014/02/01"}/
    end
    click_button "Save Assignment"
    expect(page).to have_content "Your assignment has been published."
    expect(page).to have_content("Strings (due 2/01)")
    expect(page).to have_content("Objects (due 2/02)")
    expect(page).to have_content("Triangles (due 2/03)")
  end

  scenario "Sad path: Exercise that's missing it's innards" do
    course = Fabricate(:course, title: "Cohort 4")
    signin_as :instructor, courses: [course]
    click_link "Assignments"
    click_link "New Assignment"
    expect(page).to have_options_for("Assignment",
                options: ["Cheers", "Ruby Koans", "Some Other Exercise", "Unfinished Exercise"])
    select "Unfinished Exercise", from: "Assignment"
    click_button "Set Milestones"
    expect(page).to have_content "Could not retrieve instructions.md in exercises/04-unfinished-exercise. Please confirm that the instructions.md is ready and then try again."
  end
end
