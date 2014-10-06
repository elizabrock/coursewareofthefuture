require 'rails_helper'

feature "Instructor view milestone submissions" do
  let(:course){ Fabricate(:course, start_date: "2014/01/01", end_date: "2014/03/01") }
  let!(:joe){ Fabricate(:user, name: "joe", courses: [course]) }
  let!(:jane){ Fabricate(:user, name: "jane", courses: [course]) }
  let!(:sally){ Fabricate(:user, name: "sally", courses: [course]) }
  let!(:susie){ Fabricate(:user, name: "susie", courses: [course]) }

  let(:assignment){ Fabricate(:assignment, title: "Capstone", course: course) }
  let(:milestone1){ Fabricate(:milestone, title: "Milestone 1", deadline: "2014/02/05", assignment: assignment) }
  let(:milestone2){ Fabricate(:milestone, title: "Milestone 2", deadline: "2014/02/15", assignment: assignment) }

  background do
    Fabricate(:milestone_submission, user: susie, repository: "susie/m1", milestone: milestone1)
    Fabricate(:milestone_submission, user: jane, repository: "jane/m1", milestone: milestone1)
    Fabricate(:milestone_submission, user: susie, repository: "susie/m2", milestone: milestone2)
  end

  scenario "viewing assignments index, as instructor" do
    signin_as(:instructor, name: "Eliza", courses: [course])
    click_link "Assignments"
    expect(page).to have_content("Milestone 1 (2 completed, 3 incomplete, due 2/05)")
    expect(page).to have_content("Milestone 2 (1 completed, 4 incomplete, due 2/15)")
  end

  scenario "viewing assignments index, as student" do
    signin_as(:student, courses: [course])
    click_link "Assignments"
    expect(page).not_to have_content("Milestone 1")
    expect(page).not_to have_content("Milestone 2")
  end

  scenario "viewing a milestone1's submissions" do
    signin_as(:instructor, name: "Eliza", courses: [course])
    click_link "Assignments"
    click_link "Milestone 1"
    expect(page).to have_link("susie", href: "https://github.com/susie/m1")
    expect(page).to have_link("jane", href: "https://github.com/jane/m1")
    expect(page).not_to have_link("susie", href: "https://github.com/susie/m2")
    expect(page).to have_list(["Eliza", "joe", "sally"])
  end

  scenario "viewing a milestone2's submissions" do
    signin_as(:instructor, name: "Eliza", courses: [course])
    click_link "Assignments"
    click_link "Milestone 2"
    expect(page).to have_link("susie", href: "https://github.com/susie/m2")
    expect(page).not_to have_link("susie", href: "https://github.com/susie/m1")
    expect(page).not_to have_link("jane", href: "https://github.com/jane/m1")
    expect(page).to have_list(["Eliza", "jane", "joe", "sally"])
  end
end
