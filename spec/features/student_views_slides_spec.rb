require 'spec_helper'

feature "Student views slides" do

  scenario "Student is on materials page and views slides", vcr: true do
    @course = Fabricate(:course, title: "Cohort N", start_date: "2014/01/01", end_date: "2014/02/01")
    Timecop.travel(Time.new(2013, 03, 12))
    joe = Fabricate(:instructor, github_username: "joe", github_uid: "9876")
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    visit course_path(@course)
    click_link "Materials"
    mark_as_covered("Logic")

    signin_as :student, courses: [course], github_username: "elizabrock"
    visit root_path
    click_link "Materials"
    click_link "View As Slides"
    current_path.should_include == "/materials/computer-science/logic/logic.md"
  end

end
