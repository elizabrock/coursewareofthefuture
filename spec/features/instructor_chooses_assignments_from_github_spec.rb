require 'rails_helper'

feature "Instructor chooses assignments from github", vcr: true, js: true do
  scenario "Happy Path, creating an assignment" do
    course = Fabricate(:course,
                        title: "Cohort 4",
                        start_date: "2013/02/28", end_date: "2013/06/01")
    Fabricate(:published_assignment, title: "Capstone", course: course)

    instructor = Fabricate(:instructor, courses: [course])
    instructor.photo_confirmed?.should be_truthy

    instructor2 = signin_as(instructor)
    instructor2.id.should == instructor.id
    instructor2.photo_confirmed?.should be_truthy

    Course.count.should == 1

    visit root_path
    visit course_path(course)
    click_link "Assignments"
    click_link "New Assignment"
    page.should have_options_for("Assignment",
                options: ["Cheers", "Koans Online", "Ruby Koans", "Instructions", "Unfinished Exercise"])

    select "Ruby Koans", from: "Assignment"
    click_button "Set Milestones"
    page.should have_content("publishing makes an assignment visible to students")
    page.should have_content("Strings")
    page.should have_content("Objects")
    page.should have_content("Triangles")
    fill_in "Start Date", with: "2013/03/20"
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
    page.should have_list ["Ruby Koans", "Capstone"]
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

  scenario "Sad Path, creating an assignment" do
    course = Fabricate(:course,
      title: "Cohort 4",
      start_date: "2014/01/16",
      end_date: "2014/02/03")
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Assignments"
    click_link "New Assignment"
    select "Koans Online", from: "Assignment"
    click_button "Set Milestones"
    page.should have_content("publishing makes an assignment visible to students")
    page.should have_content("Strings")
    page.should have_content("Objects")
    page.should have_content("Triangles")
    fill_in "Start Date", with: "2014/03/30"

    click_button "Save Assignment"
    page.should have_content "Your assignment could not be updated."
    page.should have_error_message("must be in the course timeframe", on: "Start Date")

    fill_in "Start Date", with: ""
    # Pretty much any deadline is A.OK. until we try to publish the assignment.
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
    page.should have_content "Your assignment has been updated."

    check "Published"
    click_button "Save Assignment"
    page.should have_content "Your assignment could not be published."
    page.should have_error_message("can't be blank", on: "Start Date")
    fill_in "Start Date", with: "2014/01/30"

    click_button "Save Assignment"
    page.should have_content "Your assignment could not be published."

    within_fieldset("Triangles Milestone") do
      find_field("Deadline").value.should =~ /#{"2014/05/28"}/
      page.should have_error_message("must be in the assignment timeframe", on: "Deadline")
      fill_in "Deadline", with: "2014/02/03"
    end
    within_fieldset("Strings Milestone") do
      find_field("Deadline").value.should =~ /#{"2013/03/24"}/
      page.should have_error_message("must be in the assignment timeframe", on: "Deadline")
      fill_in "Deadline", with: "2014/02/01"
    end
    within_fieldset("Objects Milestone") do
      find_field("Deadline").value.should == ""
      page.should have_error_message("can't be blank", on: "Deadline")
      fill_in "Deadline", with: "2014/02/02"
    end

    click_button "Save Assignment"
    page.should have_content "Your assignment has been published."
    page.should have_content("starts 1/30")
    page.should have_content("Strings (due 2/01)")
    page.should have_content("Objects (due 2/02)")
    page.should have_content("Triangles (due 2/03)")
  end
end
