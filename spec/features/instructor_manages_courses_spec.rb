require 'rails_helper'

feature "Instructor manages courses", js: true do

  scenario "Creating a course" do
    signin_as(:instructor)
    visit root_path
    click_link "Create New Course"
    page.should have_content "you can use markdown or html for your syllabus"
    page.should have_content "must be in the form of username/repo"
    fill_in "Title", with: "Cohort 4"
    fill_in "Syllabus", with: "Foobar"
    fill_in "Start Date", with: "2014/01/24"
    fill_in "End Date", with: "2014/03/24"
    fill_in "Source Repository", with: "elizabrock/source"
    click_button "Create Course"
    page.should have_content "Course successfully created"
    Course.where(title: "Cohort 4", syllabus: "Foobar",
                 start_date: "2014/01/24", end_date: "2014/03/24").count.should == 1
  end

  scenario "Failing to create a course" do
    signin_as(:instructor)
    visit root_path
    click_link "Create New Course"
    page.should have_content "you can use markdown or html for your syllabus"
    page.should have_content "must be in the form of username/repo"
    click_button "Create Course"
    page.should have_content "Course couldn't be created"
    page.should have_error_message("can't be blank", on: "Title")
    page.should have_error_message("can't be blank", on: "Syllabus")
    page.should have_error_message("can't be blank", on: "Source Repository")
    fill_in "Title", with: "Cohort 4"
    fill_in "Syllabus", with: "Foobar"
    fill_in "Start Date", with: "2014/01/24"
    fill_in "End Date", with: "2014/03/24"
    fill_in "Source Repository", with: "elizabrock/source"
    click_button "Create Course"
    page.should have_content "Course successfully created"
    Course.where(title: "Cohort 4", syllabus: "Foobar",
                 start_date: "2014/01/24", end_date: "2014/03/24").count.should == 1
    end

  scenario "Only the information for the active course is shown to students" do
    Fabricate(:course, title: "Cohort 3", end_date: 1.month.ago)
    Fabricate(:course, title: "Cohort 4", end_date: 4.days.from_now)
    Fabricate(:course, title: "Cohort 5", end_date: 2.months.from_now)
    signin_as :student
    visit root_path
    page.should have_button("Join Cohort 4")
    page.should have_button("Join Cohort 5")
  end

  scenario "Students see markdown formatted syllabus" do
    course = Fabricate(:course, title: "Cohort 4", syllabus: "This is *awesome*.")
    signin_as :student, courses: [course]
    visit root_path
    page.should have_css("em", text: "awesome")
  end

  scenario "Editing a course that already exists" do
    Fabricate(:course, title: "Cohort 4", syllabus: "This is *awesome*.")
    signin_as(:instructor)
    visit courses_path
    click_on 'edit'
    Course.where(title: "Homemade Ice Cream Making 101").count.should == 0
    fill_in "Title", with: "Homemade Ice Cream Making 101"
    click_button "Update Course"
    page.should have_content "Course successfully updated"
    Course.where(title: "Homemade Ice Cream Making 101").count.should == 1
    save_and_open_page
  end

end
