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
              name: "Jim Weirich",
              github_username: "jimweirich",
              courses: [course])
    visit root_path
    click_link "Assignments"
    click_link "Capstone"
    # Ruby legend, Jim Weirich, passed away last year.  As such, his list of
    # public repos will never again change :(
    page.should have_options_for("Assignment Repository", options: [
      "", "argus", "BankOcrKata", "beer_song", "bnr-ios-rubymotion", "builder", "dim", "docs", "dudley", "emacs-setup", "emacs-setup-esk", "emacs-starter-kit", "EverCraft-Kata", "example_blogger_with_seo", "flexmock", "gilded_rose_kata", "gimme", "Given", "gotags", "greenletters", "irb-setup", "jsblogger_sample", "kata-number-to-led", "lambda_fizz", "pair_programming_bot", "partially_valid", "Personography", "polite_programmer_blog", "polite_programmer_presentation", "presentation-connascence-examined", "presentation-given", "presentation_10papers", "presentation_agile_engineering_practices", "presentation_connascence", "presentation_enterprise_mom", "presentation_event-vs-cells", "presentation_flying_robots", "presentation_kata_and_analysis", "presentation_parenthetically_speaking", "presentation_playing_it_safe", "presentation_solid_ruby", "presentation_source_control", "presentation_testing_why_dont_we_do_it_like_this", "presentation_to_infinity", "presentation_writing_solid_ruby_code", "presentation_ynot", "present_code", "project_euler_solutions", "protection_proxy", "raffle", "rake", "rakedocs", "RakePresentations", "rava", "re", "rspec-given", "rubyspec", "sample_friends_app", "sicp-study", "slidedown", "sorcerer", "sudoku", "swimlanes", "texp", "travis_ci_flexmock_debug", "wyriki"
    ])
    page.should_not have_content "This milestone is hard"
    select "sample_friends_app", from: "Assignment Repository"
    within(milestone(1)){ click_button "Submit Milestone" }
    page.should have_content "Milestone 1 has been submitted for grading"
    within(milestone(1)){ page.should have_content "Status: Submitted for Grading" }
    # page.should have_content "Assignment Repository: jimweirich/sample_friends_app"
    page.should have_content "This milestone is hard"
    select "sample_friends_app", from: "Assignment Repository"
    within(milestone("Milestone 2")){ click_button "Submit Milestone" }
    page.should have_content "Milestone 2 has been submitted for grading"
    within(milestone("Milestone 1")){ page.should have_content "Status: Submitted for Grading" }
    within(milestone("Milestone 2")){ page.should have_content "Status: Submitted for Grading" }
  end

  scenario "student has over 30 public repos" do
    signin_as(:student,
              name: "Jim Weirich",
              github_username: "jimweirich",
              courses: [course])
    visit root_path
    click_link "Assignments"
    click_link "Capstone"
    repo_options = find_field("Assignment Repository").all("option")
    repo_options.size.should == 66
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
