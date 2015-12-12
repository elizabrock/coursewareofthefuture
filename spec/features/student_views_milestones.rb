require 'rails_helper'

feature "Student submits milestone", vcr: true do
  let(:course){ Fabricate(:course) }

  background do
    milestone = Fabricate.build(:milestone,
                                title: "Milestone 1",
                                deadline: Date.today)
    assignment = Fabricate(:published_assignment,
                           title: "Capstone",
                           course: course,
                           milestones: [
                             milestone,
                             Fabricate.build(:milestone, title: "Milestone 2", deadline: 15.days.from_now)
                           ])
    user = signin_as(:student, courses: [course])
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
