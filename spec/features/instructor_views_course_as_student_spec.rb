require 'spec_helper'

feature "Instructor views course as student", vcr: true do

  let!(:course){ Fabricate(:course) }

  scenario "Mimicking a student preserves the view across page loads" do
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    page.should have_materials_tree("inquizator-test-repo", links: true)
    click_link "View As Student"
    page.should have_content "Student View"
    page.should have_materials_tree("inquizator-test-repo", links: false)
    click_link "Assignments"
    page.should have_content "Student View"
    page.should_not have_content "New Assignment"
    click_link "Materials"
    page.should have_content "Student View"
    page.should have_materials_tree("inquizator-test-repo", links: false)
  end

  scenario "Exiting student view" do
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    click_link "View As Student"
    page.should have_content "Student View"
    page.should have_materials_tree("inquizator-test-repo", links: false)
    click_link "View As Instructor"
    page.should have_materials_tree("inquizator-test-repo", links: true)
  end

  scenario "Impersonation isn't visible to students" do
    signin_as :student, courses: [course]
    visit course_path(course)
    click_link "Materials"
    page.should_not have_content "View As Instructor"
    page.should_not have_content "View As Student"
  end
end
