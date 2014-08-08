require 'rails_helper'

feature "Student Self Report", js: true do
  # As a student
  # I want to see a calendar that allows me to self-report several metrics.
  #
  #   - self-report form should be available for each day in the past between course start date and end date
  #   - should see 'today' and other events marked on the calendar
  #   - should be able to submit a self-report form for a valid reporting day

  background do
    Timecop.travel(Time.new(2013, 03, 15))
    course = Fabricate(:course,
          title: "Cohort 4",
          start_date: "2013/03/11",
          end_date: "2013/06/20")
    Fabricate(:event, date: "2013/03/25", summary: "Federal Holiday", course: course)
    Fabricate(:event, date: "2013/03/19", summary: "No Class", course: course)
    joe = signin_as :student, name: "joe", courses: [course]
    Fabricate(:self_report,
              date: "2013/03/12",
              attended: false,
              hours_coding: 5, hours_slept: 9, hours_learning: 0, user: joe)
    Fabricate(:self_report,
              date: "2013/03/13",
              attended: true,
              hours_coding: 2, hours_slept: 7.5, hours_learning: 4, user: joe)
    click_link "Course Calendar"
  end

  after do
    Timecop.return
  end

  scenario "Student sees 'today' in calendar under today's date." do
    within("td[data-date='3/15']"){ page.should have_content "Today" }
  end

  scenario "Student sees a self-report form for days that need missing reports" do
    within("td[data-date='3/14']"){ page.should have_content "Enter Self Report!" }
    within("td[data-date='3/11']"){ page.should have_content "Enter Self Report!" }
    within("td[data-date='3/15']"){ page.should have_content "Enter Self Report!" }
    within("td[data-date='3/12']"){ page.should have_content "edit" }
    within("td[data-date='3/13']"){ page.should have_content "edit" }
  end

  scenario "Student still sees self-report form is another user has filled out their own report" do
    student = Fabricate(:student)
    Fabricate(:self_report, date: "2013/03/11", user: student)
    click_link "Course Calendar"
    within("td[data-date='3/11']"){ page.should have_content "Self-Report:" }
  end

  scenario "Student does not see self-report form for days before the class" do
    within("td[data-date='3/01']"){ page.should_not have_content "Self-Report:" }
    within("td[data-date='3/10']"){ page.should_not have_content "Self-Report:" }
    within("td[data-date='3/09']"){ page.should_not have_content "Self-Report:" }
  end

  scenario "Student sees self-report summary for days that have reports" do
    within("td[data-date='3/13']") do
      page.should have_content "Class: Attended"
      page.should have_content "Coding: 2 hours"
      page.should have_content "Sleep: 7.5 hours"
      page.should have_content "Learning: 4 hours"
    end
    within("td[data-date='3/12']") do
      page.should have_content "Class: Missed"
      page.should have_content "Coding: 5 hours"
      page.should have_content "Sleep: 9 hours"
      page.should have_content "Learning: 0 hours"
    end
  end

  scenario "Student enters self-report form" do
    within("td[data-date='3/14']") do
      click_link "Enter Self Report!"
    end
    choose "Yes"
    page.select("1", from: "Hours coding")
    page.select("2", from: "Hours learning")
    page.select("3", from: "Hours slept")
    click_button "Submit"
    within("td[data-date='3/14']") do
      page.should have_content "Class: Attended"
      page.should have_content "Coding: 1 hours"
      page.should have_content "Learning: 2 hours"
      page.should have_content "Sleep: 3 hours"
    end
  end

  scenario "Student updates a self report" do
    within("td[data-date='3/13']") do
      page.should have_content "Class: Attended"
      page.should have_content "Sleep: 7.5 hours"
      click_link "edit"
    end
    # 3/13 is the 72nd day of the year
    within("form#day72") do
      page.select("3", from: "Hours coding")
      page.select("6", from: "Hours slept")
      click_button "Submit"
    end
    within("td[data-date='3/13']") do
      page.should have_content "Class: Attended"
      page.should have_content "Coding: 3 hours"
      page.should have_content "Sleep: 6 hours"
      page.should have_content "Learning: 4 hours"
    end
  end

  scenario "Student enters empty form" do
    within("td[data-date='3/14']") do
      click_link "Enter Self Report!"
    end
    # 3/14 is the 73rd day of the year
    within("form#day73") do
      click_button "Submit"
    end
    within("form#day73") do
      page.should have_content "must be selected"
      page.should have_content "Total hours must be greater than 0"
    end
  end

  scenario "Student enters form with more than 24 hours" do
    within("td[data-date='3/14']") do
      click_link "Enter Self Report!"
    end
    # 3/14 is the 73rd day of the year
    within("form#day73") do
      choose "Yes"
      page.select("9", from: "Hours coding")
      page.select("9", from: "Hours learning")
      page.select("9", from: "Hours slept")
      click_button "Submit"
    end
    within("form#day73") do
      page.should have_content "Total hours cannot be greater than 24"
    end
  end
end
