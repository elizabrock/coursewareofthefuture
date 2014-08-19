require 'rails_helper'

feature "Student submits milestone", vcr: true do
  let(:course){ Fabricate(:course) }

  background do
    assignment = Fabricate(:assignment, title: "Capstone", course: course)
    assignment2 = Fabricate(:assignment, title: "Mid-Term", course: course)
    milestone = Fabricate(:milestone, title: "Milestone 1", deadline: Date.today, instructions: "This milestone is simple", assignment: assignment)
    Fabricate(:milestone, title: "Milestone 2", deadline: 15.days.from_now, instructions: "This milestone is hard", assignment: assignment)
    Fabricate(:milestone_submission, milestone: milestone)
  end

  scenario "Unsubmitted milestone has 'alert' css" do
    signin_as(:student,
              name: "Eliza",
              github_username: "elizabrock",
              courses: [course])
    visit root_path
    click_link "Assignments"
    click_link "Capstone"
    page.should have_css('.alert')
  end

  scenario "Submitted milestone does not have 'alert' css" do
    signin_as(:student,
              name: "Eliza",
              github_username: "elizabrock",
              courses: [course])
    visit root_path
    click_link "Assignments"
    click_link "Mid-Term"
    page.should_not have_css('.alert')
  end

end
