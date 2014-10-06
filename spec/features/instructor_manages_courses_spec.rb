require 'rails_helper'

feature "Instructor manages courses", js: true do

  scenario "Creating a course" do
    signin_as(:instructor)
    visit root_path
    click_link "Create New Course"
    expect(page).to have_content "must be in the form of username/repo"
    fill_in "Title", with: "Cohort 4"
    fill_in "Start Date", with: "2014/01/24"
    fill_in "End Date", with: "2014/03/24"
    fill_in "Source Repository", with: "elizabrock/source"
    find(:button, "Create Course", visible: false).trigger('click')
    expect(page).to have_content "Course successfully created"
    expect(Course.where(title: "Cohort 4",
                 start_date: "2014/01/24", end_date: "2014/03/24").count).to eql 1
  end

  scenario "Failing to create a course" do
    signin_as(:instructor)
    visit root_path
    click_link "Create New Course"
    expect(page).to have_content "must be in the form of username/repo"
    click_button "Create Course"
    expect(page).to have_content "Course couldn't be created"
    expect(page).to have_error_message("can't be blank", on: "Title")
    expect(page).to have_error_message("can't be blank", on: "Source Repository")
    fill_in "Title", with: "Cohort 4"
    fill_in "Start Date", with: "2014/01/24"
    fill_in "End Date", with: "2014/03/24"
    fill_in "Source Repository", with: "elizabrock/source"
    click_button "Create Course"
    expect(page).to have_content "Course successfully created"
    expect(Course.where(title: "Cohort 4",
                 start_date: "2014/01/24", end_date: "2014/03/24").count).to eql 1
    end

  scenario "Only the information for the active course is shown to students" do
    Fabricate(:course, title: "Cohort 3", end_date: 1.month.ago)
    Fabricate(:course, title: "Cohort 4", end_date: 4.days.from_now)
    Fabricate(:course, title: "Cohort 5", end_date: 2.months.from_now)
    signin_as :student
    visit root_path
    expect(page).to have_button("Join Cohort 4")
    expect(page).to have_button("Join Cohort 5")
  end

  scenario "Editing a course that already exists" do
    Fabricate(:course, title: "Cohort 4")
    signin_as(:instructor)
    visit courses_path
    click_on 'edit'
    expect(Course.where(title: "Homemade Ice Cream Making 101").count).to eql 0
    fill_in "Title", with: "Homemade Ice Cream Making 101"
    click_button "Update Course"
    expect(page).to have_content "Course successfully updated"
    expect(Course.where(title: "Homemade Ice Cream Making 101").count).to eql 1
  end

end
