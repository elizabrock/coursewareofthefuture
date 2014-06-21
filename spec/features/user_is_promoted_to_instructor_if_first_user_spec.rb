require 'rails_helper'

feature "First user is automatically made into an instructor" do
  scenario "first user in a new system is always an instructor" do
    bob = Fabricate(:user)
    signin_as(bob)
    visit root_path
    page.should have_content "Which course are you teaching today?"
  end

  scenario "second user in a new system should not be an instructor by default" do
    bob = Fabricate(:user)
    billy = Fabricate(:user)
    signin_as(billy)
    visit root_path
    page.should_not have_content "Which course are you teaching today?"
    page.should have_content "Course Enrollment"
  end

  scenario "second user can be an instructor if deliberately made that way" do
    bob = Fabricate(:user)
    bart = Fabricate(:instructor)
    signin_as(bart)
    visit root_path
    page.should have_content "Which course are you teaching today?"
    page.should_not have_content "Course Enrollment"
  end
end
