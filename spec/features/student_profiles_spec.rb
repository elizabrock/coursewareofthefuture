require 'rails_helper'

feature "Student profiles" do
  # As an instructor
  # I want my students to have profiles
  # So that I can tell them apart
  #
  # - profile image
  # - name
  # - email
  # - phone number
  # - goals
  # - background

  before do
    Fabricate(:instructor, name: "test safety instructor")
  end

  let!(:course0){ Fabricate(:course, title: "Nullth Course") }
  let!(:course){ Fabricate(:course, title: "First Course") }

  scenario "Student list is not visible to guests" do
    visit users_path
    current_path.should == root_path
    page.should have_content "You need to sign in or sign up before continuing."
  end

  scenario "Viewing the student list, as a student" do
    jill = Fabricate(:student, name: "Jill Smith", courses: [course])
    Fabricate(:student, name: "Bob Jones", courses: [course])
    Fabricate(:instructor, name: "Julia Child", courses: [course])
    Fabricate(:instructor, name: "Other Instructor")
    signin_as jill
    visit root_path
    click_link "Peers"
    within(".students") do
      page.should have_list(["Bob Jones", "Jill Smith"])
    end
    within(".instructors") do
      page.should have_content("Julia Child")
      page.should_not have_content("Other Instructor")
    end
  end

  scenario "Viewing the student list, as an instructor" do
    Fabricate(:student, name: "Jill Smith")
    Fabricate(:student, name: "Bob Jones")
    signin_as(:instructor)
    visit users_path
    page.should have_list ["Bob Jones", "Jill Smith"]
  end

  scenario "Viewing the enrollment list, as an instructor" do
    Fabricate(:student, name: "Sally", courses: [course])
    Fabricate(:student, name: "Henry", courses: [course])
    Fabricate(:student, name: "Jill Smith")
    Fabricate(:student, name: "Bob Jones")
    signin_as(:instructor)
    click_link "First Course"
    click_link "Peers"
    page.should have_list ["Henry", "Sally"]
    page.should_not have_content("Bob Jones")
    page.should_not have_content("Jill Smith")
  end

  scenario "Viewing a student's profile, as a student" do
    jill = Fabricate(:student,
              name: "Jill Smith",
              phone: "(615) 403 - 5055",
              email: "jill@smith.com",
              goals: "I want to learn Javascript.",
              background: "I know a little C.",
              github_username: "jill")
    Fabricate(:student,
              name: "Bob Jones",
              phone: "(858) 205 - 9255",
              email: "bob@jones.com",
              goals: "I want to learn rails.",
              background: "I know a little C.",
              github_username: "bob")
    signin_as jill
    visit users_path
    click_link "Bob Jones"
    page.should have_content "(858) 205 - 9255"
    page.should have_content "bob@jones.com"
    page.should_not have_content "I want to learn rails."
    page.should_not have_content "I know a little C."
    page.should_not have_content "Edit My Profile"
  end

  scenario "Viewing a student's profile, as an instructor" do
    Fabricate(:student,
              name: "Bob Jones",
              phone: "(858) 205 - 9255",
              email: "bob@jones.com",
              goals: "I want to learn rails.",
              background: "I know a little C.",
              github_username: "bobjones")
    signin_as(:instructor)
    visit users_path
    click_link "Bob Jones"
    page.should have_content "(858) 205 - 9255"
    page.should have_content "bob@jones.com"
    page.should have_content "I want to learn rails."
    page.should have_content "I know a little C."
    page.should have_content "bobjones"
    page.should_not have_content "Edit My Profile"
  end

  scenario "Editing my own profile, as an instructor" do
    me = signin_as(:instructor)
    click_link "My Profile"
    click_link "Edit My Profile"
    fill_in "Name", with: "Julia Myers"
    fill_in "Email", with: "jill@myers.com"
    fill_in "Phone", with: "(615) 403 - 5055"
    page.should_not have_content "Goals"
    click_button "Save Changes"
    current_path.should == user_path(me)
    page.should have_content "Your profile has been updated"
    page.should have_content "Julia Myers"
    page.should have_content "(615) 403 - 5055"
    page.should have_content "jill@myers.com"
  end

  scenario "Editing my own profile, as a student" do
    jill = Fabricate(:student, name: "Jillian Smith")
    signin_as jill
    click_link "My Profile"
    click_link "Edit My Profile"
    fill_in "Name", with: "Jill Smith"
    fill_in "Email", with: "jill@smith.com"
    fill_in "Phone", with: "(615) 403 - 5055"
    fill_in "Goals", with: "I want to learn rails."
    fill_in "Background", with: "I know a little C."
    click_button "Save Changes"
    current_path.should == user_path(jill)
    page.should have_content "Your profile has been updated"
    page.should have_content "Jill Smith"
    page.should have_content "(615) 403 - 5055"
    page.should have_content "jill@smith.com"
    page.should have_content "I want to learn rails."
    page.should have_content "I know a little C."
  end

  scenario "Invalid profile update" do
    jill = Fabricate(:student, name: "Jillian Smith", email: "jill@smith.com")
    signin_as jill
    click_link "My Profile"
    click_link "Edit My Profile"
    fill_in "Email", with: "jillsmith.com"
    click_button "Save Changes"
    page.should have_content "must be an email address"
    visit user_path(jill)
    page.should have_content "jill@smith.com"
    page.should_not have_content "jillsmith.com"
  end
end
