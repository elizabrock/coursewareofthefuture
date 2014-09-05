require 'rails_helper'

# As a public viewer
# I want to view a student's profile
# So that I can gain more information on their abilities/contact details
#
# - profile image
# - name
# - email
# - phone number
# - assignments
# - link to Github repo

feature "Public student profiles" do

  before do
    will = Fabricate(:student, name: "Will Smith", phone: "615-555-9876", email: "will@example.com")
    milestone1 = Fabricate(:milestone, title: "Make things", instructions: "This is how to make things")
    milestone_submission = Fabricate(:milestone_submission, user: will, milestone: milestone1)
  end

  scenario "View student's profile" do
    visit root_path
    click_link "View Student List"
    click_link "Will Smith"
    expect(page).to have_content("Will Smith")
    expect(page).to have_content("615-555-9876")
    expect(page).to have_content("will@example.com")
  end
end
