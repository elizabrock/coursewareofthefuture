require 'rails_helper'

feature "Instructor authentication" do
  # As a instructor
  # I want to be able to sign in/sign out/reset my password
  #
  # - Standard password reset via. email
  # - Standard Sign In/Sign Out

  scenario "Instructor can log in and log out with email" do
    joe = Fabricate(:instructor, github_username: "joe", github_uid: "9876")
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    expect(page).to have_content "Successfully authenticated from Github account"
    expect(page).to have_content "Sign Out"
    expect(page).not_to have_content "Sign In"
    click_link "Sign Out"
    expect(page).not_to have_content "Sign Out"
    expect(page).to have_content "Sign In"
  end

  scenario "Instructor can remark self as instructor" do
    instructor = signin_as(:instructor)
    visit root_path
    visit user_path(instructor)
    expect(page).not_to have_button "Make Instructor"
  end

  scenario "Instructor can create another instructor" do
    Fabricate(:user, name: "Joe Smith")
    Fabricate(:user, name: "Sally Myers")
    signin_as(:instructor)
    visit root_path
    click_link "View All Students"
    click_link "Sally Myers"
    click_button "Make Instructor"
    expect(page).to have_content "Sally Myers is now an instructor."
    expect(current_path).to eql users_path
    expect(User.where(name: "Sally Myers", instructor: true).count).to eql 1
    within(".instructors") do
      expect(page).to have_content "Sally Myers"
    end
  end

  scenario "Student cannot create another instructor" do
    Fabricate(:user, name: "Joe Smith")
    Fabricate(:user, name: "Sally Myers")
    signin_as(:instructor)
    visit root_path
    click_link "View All Students"
    expect(page).not_to have_content "Make Instructor"
  end
end
