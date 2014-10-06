require 'rails_helper'

feature "Switching between courses", vcr: true do
  scenario "switching between courses" do
    front_end = Fabricate(:course,
                  title: "Front-End Development",
                  source_repository: "elizabrock/NSS-Syllabus-Cohort-3",
                  start_date: 4.days.ago,
                  end_date: 2.months.from_now)
    Fabricate(:event, date: 1.day.from_now, summary: "Day Off", course: front_end)
    Fabricate(:event, date: 2.days.from_now, summary: "Not a Day Off", course: front_end)

    Fabricate(:instructor)
    Fabricate(:student, name: "Jim", courses: [front_end])
    Fabricate(:student, name: "Joe", courses: [front_end])

    fundamentals = Fabricate(:course,
                          title: "Software Development Fundamentals",
                          source_repository: "elizabrock/inquizator-test-repo",
                          start_date: 1.month.ago,
                          end_date: 2.months.from_now)

    Fabricate(:event, date: 9.days.ago, summary: "Grinchmas", course: fundamentals)
    Fabricate(:event, date: 5.days.from_now, summary: "Airing of Grievances", course: fundamentals)
    Fabricate(:student, name: "Susie", courses: [fundamentals])
    Fabricate(:student, name: "Sally", courses: [fundamentals])

    Fabricate(:course, title: "Past Course", start_date: 18.months.ago, end_date: 1.year.ago)
    Fabricate(:course, title: "Future Course", start_date: 2.months.from_now, end_date: 4.months.from_now)

    signin_as(:instructor)
    visit root_path
    expect(page).to have_content "Which course are you teaching today?"

    expect(page).to have_list(["Front-End Development", "Software Development Fundamentals", "Future Course"])
    expect(page).not_to have_content "Past Course"

    click_link "Software Development Fundamentals"
    expect(page).to have_content "Grinchmas"
    expect(page).to have_content "Airing of Grievances"
    click_link "Peers"
    expect(page).to have_list ["Sally", "Susie"]
    expect(page).not_to have_content("Jim")
    expect(page).not_to have_content("Joe")
    click_link "Materials"
    expect(page).to have_content "Computer Science"
    expect(page).not_to have_content "Unit 1"
    click_link "Course Calendar"
    expect(page).to have_content "Grinchmas"
    expect(page).to have_content "Airing of Grievances"
    expect(page).not_to have_content "Day Off"

    click_link "Front-End Development"
    expect(page).to have_content "Day Off"
    expect(page).to have_content "Not a Day Off"
    expect(page).not_to have_content "Grinchmas"
    click_link "Peers"
    expect(page).to have_content "Jim"
    expect(page).to have_content "Joe"
    expect(page).not_to have_content "Susie"
    expect(page).not_to have_content "Sally"
    click_link "Materials"
    expect(page).to have_content "Unit1"
    expect(page).not_to have_content "Computer Science"
    click_link "Course Calendar"
    expect(page).to have_content "Day Off"
    expect(page).to have_content "Not a Day Off"
    expect(page).not_to have_content "Grinchmas"
  end
end
