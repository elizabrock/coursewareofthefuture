require 'rails_helper'

feature "Student submits milestone", vcr: true do
  let(:course){ Fabricate(:course) }

  background do
    assignment = Fabricate(:assignment, title: "Capstone", course: course)
    assignment2 = Fabricate(:assignment, title: "Mid-Term", course: course)
    milestone = Fabricate(:milestone, title: "Milestone 1", deadline: Date.today, instructions: "This milestone is simple", assignment: assignment)
    user = signin_as(:student, courses: [course])
    Fabricate(:milestone, title: "Milestone 2", deadline: 15.days.from_now, instructions: "This milestone is hard", assignment: assignment)
    Fabricate(:milestone_submission, milestone: milestone, user: user)
  end

  scenario "Unsubmitted milestone has 'alert' css" do
    visit course_calendar_path course
    find(:link, "Capstone: Milestone 2 Due").find(:xpath, "..")[:class].should include('alert')
  end

  scenario "Submitted milestone does not have 'alert' css" do
    visit course_calendar_path course
    find(:link, "Capstone: Milestone 1 Due").find(:xpath, "..")[:class].should_not include('alert')
  end

end
