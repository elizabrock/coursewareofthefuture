require 'rails_helper'

feature "Users see course navigation when viewing student profiles" do

  let!(:course){ Fabricate(:course, title: "Knitting") }

  scenario "When you haven't visited the course yet (e.g. direct link)" do
    signin_as :student
    sally = Fabricate(:student, github_username: "ssmith", name: "Sally Smith")
    visit user_path(sally)
    expect(page).to have_content "Sally Smith"
    expect(page).not_to have_content "Materials"
    expect(page).not_to have_content "Calendar"
  end

  scenario "Navigating to my student profile while looking at a course" do
    me = signin_as :student, courses: [course]
    click_link "My Profile"
    expect(current_path).to eql user_path(me)
    expect(page).to have_content "Materials"
    expect(page).to have_content "Calendar"
  end

  scenario "Navigating to my instructor profile while looking at a course" do
    me = signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "My Profile"
    expect(current_path).to eql user_path(me)
    expect(page).to have_content "Materials"
    expect(page).to have_content "Calendar"
  end

  scenario "Navigating to my profile from a non-course page (as a student)" do
    enrollable_course = Fabricate(:course)
    me = signin_as :student, courses: [course]
    click_link "Enroll in another course"
    click_link "My Profile"
    expect(current_path).to eql user_path(me)
    expect(page).not_to have_content "Materials"
    expect(page).not_to have_content "Calendar"
  end

  scenario "Navigating to my profile from a non-course page (as an instructor)" do
    me = signin_as :instructor, courses: [course]
    visit root_path
    click_link "My Profile"
    expect(current_path).to eql user_path(me)
    expect(page).not_to have_content "Materials"
    expect(page).not_to have_content "Calendar"
  end

  scenario "When a student navigates to a student via. the peers page" do
    Fabricate(:student, name: "Joe Smith", email: "joe@smith.com", courses: [course])
    Fabricate(:student, name: "June Smith", email: "june@smith.com", courses: [course])
    signin_as :student, courses: [course]
    click_link "Peers"
    click_link "June Smith"
    expect(page).to have_content "June Smith"
    expect(page).to have_content "june@smith.com"
    expect(page).to have_content "Materials"
    expect(page).to have_content "Calendar"
  end

  scenario "When an instructor navigates to a student via. the peers page" do
    Fabricate(:student, name: "Joe Smith", email: "joe@smith.com", courses: [course])
    Fabricate(:student, name: "June Smith", email: "june@smith.com", courses: [course])
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Peers"
    click_link "June Smith"
    expect(page).to have_content "June Smith"
    expect(page).to have_content "june@smith.com"
    expect(page).to have_content "Materials"
    expect(page).to have_content "Calendar"
  end

  scenario "When you've navigated to a student via. the full student list" do
    Fabricate(:student, name: "Joe Smith", email: "joe@smith.com", courses: [course])
    Fabricate(:student, name: "June Smith", email: "june@smith.com", courses: [course])
    signin_as :instructor, courses: [course]
    visit root_path
    click_link "View All Students"
    click_link "June Smith"
    expect(page).to have_content "June Smith"
    expect(page).to have_content "june@smith.com"
  end
end
