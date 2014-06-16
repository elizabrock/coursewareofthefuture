require 'rails_helper'

feature "Self Report Count" do

  let!(:new_course) { Fabricate(:course,
    start_date: 7.days.ago,
    end_date: 10.days.from_now)}
  let!(:old_course) {Fabricate(:course,
    start_date: 20.days.ago,
    end_date: 8.days.ago)}
  let!(:joe) { Fabricate :student, name: "joe", courses: [new_course, old_course] }
  let!(:bob) { Fabricate :student, name: "bob", courses: [old_course] }

  scenario "student should see missing self-reports total in nav bar" do
    signin_as joe
    visit course_path new_course
    page.should have_css('.count_icon', text:'7')

    Fabricate(:self_report, date: 2.days.ago, user: joe)
    visit course_path new_course
    page.should have_css('.count_icon', text:'6')

    Fabricate(:self_report, date: 1.day.ago, user: joe)
    visit course_path new_course
    page.should have_css('.count_icon', text:'5')
  end

  scenario "self-reports total should reflect current user and course timeframe" do
    signin_as bob
    visit root_path
    page.should have_css('.count_icon', text:'12')

    Fabricate(:self_report, date: 1.day.ago, user: bob)

    visit root_path
    page.should have_css('.count_icon', text:'12')

    Fabricate(:self_report, date: 9.days.ago, user: bob)

    visit root_path
    page.should have_css('.count_icon', text:'11')

    Fabricate(:self_report, date: 8.days.ago, user: joe)

    visit root_path
    page.should have_css('.count_icon', text:'11')
  end

  scenario "self_reports total should reflect current course" do
    signin_as joe

    visit course_path old_course
    page.should have_css('.count_icon', text:'12')

    visit course_path new_course
    page.should have_css('.count_icon', text:'7')

    Fabricate(:self_report, date: 9.days.ago, user: joe)
    Fabricate(:self_report, date: 10.days.ago, user: joe)

    visit course_path old_course
    page.should have_css('.count_icon', text:'10')

    visit course_path new_course
    page.should have_css('.count_icon', text:'7')

    Fabricate(:self_report, date: 1.day.ago, user: joe)

    visit course_path old_course
    page.should have_css('.count_icon', text:'10')

    visit course_path new_course
    page.should have_css('.count_icon', text:'6')

  end
end
