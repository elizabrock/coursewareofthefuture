require 'rails_helper'

feature "Student authentication" do
  # As a student
  # I want to be able to sign up/sign in/sign out
  #
  # - Standard account creation with OAuth
  # - Standard login/logout

  scenario "Student signs up via. Github", vcr: true do
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    expect(page).to have_content "Successfully authenticated from Github account."
    expect(page).to have_content "Sign Out"
    expect(page).not_to have_content "Sign In"
    click_link "Sign Out"
    expect(page).not_to have_content "Sign Out"
    expect(page).to have_content "Sign In with Github"
    expect(User.where(
      email: "joesmith@example.com",
      github_uid: "12345",
      github_username: "joe",
      name: "Joe Smith",
      github_access_token: ENV["GITHUB_ACCESS_TOKEN"],
    ).count).to eql 1
    expect(User.count).to eql 1
  end

  scenario "Student can log in and log out with github" do
    Fabricate(:student,
      github_uid: "12345",
      email: "joe@example.com",
      github_username: "joe")
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    expect(page).to have_content "Successfully authenticated from Github account."
    expect(page).to have_content "Sign Out"
    expect(page).not_to have_content "Sign In"
    click_link "Sign Out"
    expect(page).not_to have_content "Sign Out"
    expect(page).to have_content "Sign In with Github"
    expect(User.count).to eql 1
  end

  scenario "No more sign ups" do
    visit root_path
    expect(page).not_to have_content "Sign Up"
  end

  scenario "Fix: revoked authorization breaks github auth" do
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    expect(User.where(
      email: "joesmith@example.com",
      github_uid: "12345",
      github_username: "joe",
      name: "Joe Smith",
      github_access_token: ENV["GITHUB_ACCESS_TOKEN"],
    ).count).to eql 1
    click_link "Sign Out"

    # This should update the user token:
    sign_into_github_as("joe", token: 8675301)
    click_link "Sign In with Github"
    expect(User.where(
      email: "joesmith@example.com",
      github_uid: "12345",
      github_username: "joe",
      name: "Joe Smith",
      github_access_token: "8675301",
    ).count).to eql 1
    expect(User.count).to eql 1
  end
end
