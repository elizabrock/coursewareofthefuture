require 'rails_helper'

feature "Switching between courses", vcr: true do
  scenario "switching between courses" do
    Timecop.travel(Time.new(2013, 03, 24))
    front_end = Fabricate(:course,
                  title: "Front-End Development",
                  source_repository: "elizabrock/NSS-Syllabus-Cohort-3",
                  start_date: "2014/03/20",
                  end_date: "2014/06/20",
                  syllabus: "Zed Double You")
    Fabricate(:event, date: "2014/03/25", summary: "Day Off", course: front_end)
    Fabricate(:event, date: "2014/03/26", summary: "Not Day Off", course: front_end)

    Fabricate(:student, name: "Jim", courses: [front_end])
    Fabricate(:student, name: "Joe", courses: [front_end])

    fundamentals = Fabricate(:course,
                          title: "Software Development Fundamentals",
                          source_repository: "elizabrock/inquizator-test-repo",
                          start_date: "2014/02/20",
                          end_date: "2014/05/20",
                          syllabus: "Foo Bar")
    Fabricate(:event, date: "2014/03/15", summary: "Grinchmas", course: fundamentals)
    Fabricate(:event, date: "2014/03/29", summary: "Airing of Grievances", course: fundamentals)
    Fabricate(:student, name: "Susie", courses: [fundamentals])
    Fabricate(:student, name: "Sally", courses: [fundamentals])

    Fabricate(:course, title: "Past Course", start_date: "2012/01/01", end_date: "2012/04/01")
    Fabricate(:course, title: "Future Course", start_date: "2014/05/06", end_date: "2014/06/07")

    signin_as(:instructor)
    visit root_path
    page.should have_content "Which course are you teaching today?"

    page.should have_list(["Front-End Development", "Software Development Fundamentals", "Future Course"])
    page.should_not have_content "Past Course"
    click_link "Software Development Fundamentals"
    page.should have_content "Foo Bar"
    click_link "Syllabus"
    page.should have_content "Foo Bar"
    click_link "Peers"
    page.should have_list ["Sally", "Susie"]
    page.should_not have_content("Jim")
    page.should_not have_content("Joe")
    click_link "Materials"
    page.should have_content "Computer Science"
    page.should_not have_content "Unit 1"
    click_link "Course Calendar"
    page.should have_content "Grinchmas"
    page.should_not have_content "Day Off"
    click_link "Front-End Development"
    page.should have_content "Zed Double You"
    click_link "Syllabus"
    page.should have_content "Zed Double You"
    click_link "Peers"
    page.should have_content "Jim"
    page.should have_content "Joe"
    page.should_not have_content "Susie"
    page.should_not have_content "Sally"
    click_link "Materials"
    page.should have_content "Unit1"
    page.should_not have_content "Computer Science"
    click_link "Course Calendar"
    page.should have_content "Day Off"
    page.should_not have_content "Grinchmas"
  end
end
