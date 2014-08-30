require 'rails_helper'

feature "User observes course" do

  scenario "Instructor can make a student an observer" do
    Fabricate(:user, name: "Joe Smith")
    Fabricate(:user, name: "Sally Myers")
    signin_as(:instructor)
    visit root_path
    click_link "View All Students"
    click_link "Sally Myers"
    click_button "Make Observer"
    expect(page).to have_content "Sally Myers is now an observer."
    expect(current_path).to eql users_path
    expect(User.where(name: "Sally Myers", observer: true).count).to eql 1
    within(".observers") do
      expect(page).to have_content "Sally Myers"
    end
    within(".students") do
      expect(page).not_to have_content "Sally Myers"
    end
  end

  scenario "Instructor can make an instructor an observer" do
    Fabricate(:user, name: "Joe Smith")
    Fabricate(:instructor, name: "Sally Myers")
    signin_as(:instructor)
    visit root_path
    click_link "View All Students"
    within(".instructors") do
      expect(page).to have_content "Sally Myers"
    end
    within(".observers") do
      expect(page).not_to have_content "Sally Myers"
    end
    click_link "Sally Myers"
    click_button "Make Observer"
    within(".observers") do
      expect(page).to have_content "Sally Myers"
    end
    within(".instructors") do
      expect(page).not_to have_content "Sally Myers"
    end
  end

  scenario "Instructor cannot make self an observer" do
    instructor = signin_as(:instructor)
    visit user_path(instructor)
    expect(page).not_to have_button "Make Observer"
  end
end
