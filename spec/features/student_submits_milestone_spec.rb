require 'rails_helper'

feature "Student submits milestone", vcr: true do
  let(:course){ Fabricate(:course) }

  background do
    assignment = Fabricate(:assignment, title: "Capstone", course: course)
    Fabricate(:milestone, title: "Milestone 1", deadline: Date.today, instructions: "This milestone is simple", assignment: assignment)
    Fabricate(:milestone, title: "Milestone 2", deadline: 15.days.from_now, instructions: "This milestone is hard", assignment: assignment)
  end

  scenario "Submitting milestone, happy path" do
    signin_as(:student,
              name: "Eliza",
              github_username: "elizabrock",
              courses: [course])
    visit root_path
    click_link "Assignments"
    click_link "Capstone"
    # This is not ideal, since it will change when Eliza has more public repos.
    # However, the effort required to set up a proper test user doesn't seem warranted yet.
    page.should have_options_for("Assignment Repository", options: [
      "",
      "blueberry-cal",
      "coursewareofthefuture",
      "coveralls-ruby",
      "deadsets",
      "fabrication",
      "FuturePerfect",
      "inquizator-test-repo",
      "Intro-to-Rails-3-Presentation",
      "LaTeX-Resume",
      "license-to-kill",
      "linked_list_cohort3",
      "linked_list_cohort_blueberry",
      "linked_list_cohort_tangerine",
      "monologue",
      "NSS-basic-rails-blog",
      "nss-cal",
      "nss-capstone-2-example",
      "NSS-CLI-test-example",
      "NSS-futureperfect-CLI",
      "NSS-futureperfect-rails",
      "NSS-Ruby-Koans",
      "nss-squawker",
      "NSS-Syllabus-Cohort-3",
      "NSS-Syllabus-Fall-2012",
      "NSS-Syllabus-Spring-2013",
      "NSS-Test-Repo",
      "presentation_nashville_hack_day",
      "project_management_export_to_latex",
      "SavingsMultipliedRedux",
      "slide-em-up",
      "software-development-curriculum",
      "software-development-curriculum-mark-two",
      "squmblr",
      "tapestry",
      "testing_cheers",
      "tr3w-conversion",
      "wedding"
    ])
    page.should_not have_content "This milestone is hard"
    select "software-development-curriculum", from: "Assignment Repository"
    within(milestone(1)){ click_button "Submit Milestone" }
    page.should have_content "Milestone 1 has been submitted for grading"
    within(milestone(1)){ page.should have_content "Status: Submitted for Grading" }
    # page.should have_content "Assignment Repository: elizabrock/software-development-curriculum"
    page.should have_content "This milestone is hard"
    select "software-development-curriculum", from: "Assignment Repository"
    within(milestone("Milestone 2")){ click_button "Submit Milestone" }
    page.should have_content "Milestone 2 has been submitted for grading"
    within(milestone("Milestone 1")){ page.should have_content "Status: Submitted for Grading" }
    within(milestone("Milestone 2")){ page.should have_content "Status: Submitted for Grading" }
  end

  scenario "student has over 30 public repos" do
    signin_as(:student,
              name: "Samantha",
              github_username: "slyeargin",
              courses: [course])
    visit root_path
    click_link "Assignments"
    click_link "Capstone"
    repo_options = find_field("Assignment Repository").all("option")
    repo_options.size.should == 49
  end

  scenario "Student has no public repos?" do
    signin_as(:student,
              name: "That Guy That Has No Repos",
              github_username: "bob1",
              courses: [course])
    visit root_path
    click_link "Assignments"
    click_link "Capstone"
    page.should have_css(".error", text: "You must have public repos in order to submit milestones")
  end

  scenario "Resubmitting Milestone" do
    pending
    fail
  end

  scenario "User can't submit milestone for a course they aren't enrolled in" do
    pending
    fail
  end


end
