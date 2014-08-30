require 'rails_helper'

feature "Instructor manages course calendar", js: true do

  scenario "Students shouldn't see 'New Event' button" do
    cohort4 = Fabricate(:course,
              title: "Cohort 4",
              start_date: "2014/01/24",
              end_date: "2014/03/24")
    signin_as :student, courses: [cohort4]
    visit course_calendar_path(cohort4)
    expect(page).not_to have_content "New Event"
  end

  scenario "Adding days off" do
    cohort4 = Fabricate(:course,
              title: "Cohort 4",
              start_date: "2014/01/24",
              end_date: "2014/03/24")
    signin_as :instructor, courses: [cohort4]
    visit course_calendar_path(cohort4)
    click_link "Add New Event"
    fill_in "Date", with: "2014/02/24"
    fill_in "Summary", with: "Federal Holiday"
    click_button "Create Event"

    expect(page).to have_content "Event successfully created."
    expect(current_path).to eql course_calendar_path(cohort4)
    expect(page).to have_calendar_entry("2/24", text: "Federal Holiday")
  end

  scenario "Sad path of adding days off" do
    cohort4 = Fabricate(:course,
              title: "Cohort 4",
              start_date: "2014/01/24",
              end_date: "2014/03/24")
    signin_as :instructor, courses: [cohort4]
    visit course_calendar_path(cohort4)
    click_link "Add New Event"
    fill_in "Date", with: "2013/02/19"
    click_button "Create Event"
    expect(page).to have_content "Event couldn't be created."
    expect(page).to have_error_message("can't be blank", on: "Summary")
    expect(page).to have_error_message("must be during the course", on: "Date")
    fill_in "Date", with: "2014/02/19"
    fill_in "Summary", with: "Federal Holiday"
    click_button "Create Event"
    expect(page).to have_content "Event successfully created."
    expect(current_path).to eql course_calendar_path(cohort4)
    expect(page).to have_calendar_entry("2/19", text: "Federal Holiday")
  end

  scenario "Viewing course calendar" do
    course = Fabricate(:course,
              title: "Cohort 4",
              start_date: "2013/09/12",
              end_date: "2014/01/15")
    Fabricate(:event, date: "2013/10/15", summary: "Federal Holiday", course: course)
    Fabricate(:event, date: "2014/01/10", summary: "No Class", course: course)
    signin_as :student, courses: [course]
    visit root_path
    expect(page).to have_content("October")
    expect(page).to have_content("November")
    expect(page).to have_content("December")
    expect(page).to have_content("January")
    expect(page).to have_calendar_entry("9/12", text: "First Day of Class")
    expect(page).to have_calendar_entry("1/15", text: "Last Day of Class")
    expect(page).to have_calendar_entry("1/10", text: "No Class")
    expect(page).to have_calendar_entry("10/15", text: "Federal Holiday")
  end

  scenario "Fix: displaying multiple events a day" do
    course = Fabricate(:course,
                title: "Cohort 4",
                start_date: "2013/09/12",
                end_date: "2014/01/15")
    signin_as :student, courses: [course]

    Fabricate(:event, date: "2013/10/15", summary: "Federal Holiday", course: course)
    Fabricate(:event, date: "2013/10/15", summary: "No Class", course: course)

    visit course_calendar_path(course)
    expect(page).to have_calendar_entry("10/15", text: "Federal Holiday")
    expect(page).to have_calendar_entry("10/15", text: "No Class")
  end
end
