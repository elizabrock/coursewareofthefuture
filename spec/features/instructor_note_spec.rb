require 'rails_helper'

feature "Instructor Note", js:true do

  background do
    Timecop.travel(Time.new(2013, 03, 15))
    course = Fabricate(:course,
          title: "Cohort 4",
          start_date: "2013/03/11",
          end_date: "2013/06/20")
    Fabricate(:event, date: "2013/03/25", summary: "Federal Holiday", course: course)
    Fabricate(:event, date: "2013/03/19", summary: "No Class", course: course)
    joe = signin_as :instructor, courses: [course]
    Fabricate(:note,
              date: "2013/03/12",
              content: "new note",
              course: course,
              user: joe)
    Fabricate(:note,
              date: "2013/03/13",
              content: "another new note",
              course: course,
              user: joe)
    click_link "Course Calendar"
  end

  after do
    Timecop.return
  end

  scenario "Instructor sees 'today' in calendar under today's date." do
    within("td[data-date='3/15']"){ page.should have_content "Today" }
  end

  scenario "Instructor sees note form for days that need notes" do
    within("td[data-date='3/11']"){ page.should have_content "Instructor Note!" }
    within("td[data-date='3/12']"){ page.should have_content "edit" }
    within("td[data-date='3/13']"){ page.should have_content "edit" }
    within("td[data-date='3/14']"){ page.should have_content "Instructor Note!" }
    within("td[data-date='3/15']"){ page.should have_content "Instructor Note!" }
  end

  scenario "Instructor does not see note form for days outside the course" do
    within("td[data-date='3/01']"){ page.should_not have_content "Instructor Note" }
    within("td[data-date='3/10']"){ page.should_not have_content "Instructor Note" }
    within("td[data-date='3/09']"){ page.should_not have_content "Instructor Note" }
  end

  scenario 'Instructor sees notes for days that have notes' do
    within("td[data-date='3/12']"){ page.should have_content "new note"}
    within("td[data-date='3/13']"){ page.should have_content "another new note"}
  end

  scenario 'Instructor enters notes' do
    within("td[data-date='6/14']") do
      click_link "Instructor Note!"
    end

    fill_in "Note", with: "daily note"
    click_button "Noted"

    within("td[data-date='6/14']") do
      page.should have_content "daily note"
    end
  end

  scenario 'Instructor enters empty form' do
    within("td[data-date='3/20']") do
      click_link "Instructor Note!"
    end

    within("form#day79") do
      click_button "Noted"
    end

    within("form#day79") do
      page.should have_content "can't be blank"
    end
  end


end
