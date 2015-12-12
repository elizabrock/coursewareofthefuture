require 'rails_helper'

feature "Instructor view milestone submissions" do
  let(:course){ Fabricate(:course, start_date: "2014/01/01", end_date: "2014/03/01") }
  let!(:joe){ Fabricate(:user, name: "joe", courses: [course], github_username: "joe") }
  let!(:jane){ Fabricate(:user, name: "jane", courses: [course], github_username: "jane") }
  let!(:sally){ Fabricate(:user, name: "sally", courses: [course], github_username: "sally") }
  let!(:susie){ Fabricate(:user, name: "susie", courses: [course], github_username: "susie") }

  let!(:assignment){ Fabricate(:published_assignment, title: "Capstone", course: course, milestones: [milestone1, milestone2]) }
  let(:milestone1){ Fabricate.build(:milestone, title: "Milestone 1", deadline: "2014/02/05") }
  let(:milestone2){ Fabricate.build(:milestone, title: "Milestone 2", deadline: "2014/02/15") }

  background do
    Fabricate(:milestone_submission, user: susie, repository: "m1", milestone: milestone1)
    Fabricate(:milestone_submission, user: jane, repository: "m1", milestone: milestone1)
    Fabricate(:milestone_submission, user: susie, repository: "m2", milestone: milestone2)
  end

  scenario "viewing assignments index, as instructor" do
    signin_as(:instructor, name: "Eliza", courses: [course])
    click_link "Assignments"
    page.should have_content("Milestone 1 (2 completed, 3 incomplete, due 2/05)")
    page.should have_content("Milestone 2 (1 completed, 4 incomplete, due 2/15)")
  end

  scenario "viewing assignments index, as student" do
    signin_as(:student, courses: [course])
    click_link "Assignments"
    page.should_not have_content("Milestone 1")
    page.should_not have_content("Milestone 2")
  end

  scenario "viewing a milestone1's submissions" do
    signin_as(:instructor, name: "Eliza", courses: [course])
    click_link "Assignments"
    click_link "Milestone 1"
    page.should have_link("susie", href: "https://github.com/susie/m1")
    page.should have_link("jane", href: "https://github.com/jane/m1")
    page.should_not have_link("susie", href: "https://github.com/susie/m2")
    page.should have_list(["Eliza", "joe", "sally"])
  end

  scenario "viewing a milestone2's submissions" do
    signin_as(:instructor, name: "Eliza", courses: [course])
    click_link "Assignments"
    click_link "Milestone 2"
    page.should have_link("susie", href: "https://github.com/susie/m2")
    page.should_not have_link("susie", href: "https://github.com/susie/m1")
    page.should_not have_link("jane", href: "https://github.com/jane/m1")
    page.should have_list(["Eliza", "jane", "joe", "sally"])
  end
end
