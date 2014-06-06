require 'spec_helper'

feature "Instructor chooses assignments from github", vcr: true, js: true do

  scenario "Happy Path, creating an assignment" do
    Timecop.travel(Time.new(2013, 03, 01)) do
      course = Fabricate(:course,
                         title: "Cohort 4",
                         start_date: "2013/02/28", end_date: "2013/06/01")
      Fabricate(:assignment, title: "Capstone", course: course)

      instructor = Fabricate(:instructor, courses: [course])
      instructor.photo_confirmed?.should be_true

      instructor2 = signin_as(instructor)
      instructor2.id.should == instructor.id
      instructor2.photo_confirmed?.should be_true

      Course.count.should == 1

      visit root_path
      visit course_path(course)
      click_link "Assignments"
      click_link "New Assignment"
      page.should have_options_for("Assignment",
                  options: ["Cheers", "Ruby Koans", "Some Other Exercise", "Unfinished Exercise"])
      select "Ruby Koans", from: "Assignment"
      click_button "Set Milestones"
      page.should have_content("Strings")
      page.should have_content("Objects")
      page.should have_content("Triangles")
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
      page.should have_content("Strings (due 3/24)")
      page.should have_content("Objects (due 4/28)")
      page.should have_content("Triangles (due 5/28)")
      within(milestone("Strings")) do
        page.should have_content "Strings are basically arrays."
      end
      within(milestone("Objects")) do
        page.should have_content "Objects are bloby."
      end
      within(milestone("Triangles")) do
        page.should have_content "Triangles are shapes."
      end
    end
  end

  scenario "Sad Path, creating an assignment" do
    Timecop.travel(Time.new(2014, 02, 01)) do
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
      page.should have_content("Strings")
      page.should have_content("Objects")
      page.should have_content("Triangles")
      within_fieldset("Strings Milestone") do
        fill_in "Deadline", with: "2013/03/24"
      end
      within_fieldset("Objects Milestone") do
        fill_in "Deadline", with: "2014/01/28"
      end
      within_fieldset("Triangles Milestone") do
        fill_in "Deadline", with: "2014/05/28"
      end
      click_button "Save Assignment"
      page.should have_content "Your assignment could not be updated."
      within_fieldset("Triangles Milestone") do
        page.should have_error_message("Must be in the course timeframe", on: "Deadline")
        find_field("Deadline").value.should =~ /#{"2014/05/28"}/
        fill_in "Deadline", with: "2014/02/03"
      end
      within_fieldset("Strings Milestone") do
        page.should have_error_message("Must be in the course timeframe", on: "Deadline")
        fill_in "Deadline", with: "2014/02/01"
      end
      within_fieldset("Objects Milestone") do
        find_field("Deadline").value.should =~ /#{"2014/01/28"}/
        fill_in "Deadline", with: "2014/02/02"
      end
      click_button "Save Assignment"
      page.should have_content "Your assignment has been updated."
      page.should have_content("Strings (due 2/01)")
      page.should have_content("Objects (due 2/02)")
      page.should have_content("Triangles (due 2/03)")
    end
  end

  scenario "Sad path: Exercise that's missing it's innards" do
    Timecop.travel(Time.new(2013, 03, 01)) do
      course = Fabricate(:course, title: "Cohort 4")
      signin_as :instructor, courses: [course]
      click_link "Assignments"
      click_link "New Assignment"
      page.should have_options_for("Assignment",
                  options: ["Cheers", "Ruby Koans", "Some Other Exercise", "Unfinished Exercise"])
      select "Unfinished Exercise", from: "Assignment"
      click_button "Set Milestones"
      page.should have_content "Could not retrieve instructions.md in exercises/04-unfinished-exercise. Please confirm that the instructions.md is ready and then try again."
    end
  end
end
