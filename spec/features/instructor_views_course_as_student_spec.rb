require 'rails_helper'

feature "Instructor views course as student", vcr: true do

  let!(:course){ Fabricate(:course) }

  scenario "Mimicking a student preserves the view across page loads" do
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    hash_of("#all_materials").should == materials_list
    click_link "View As Student"
    page.should have_content "Student View"
    hash_of("#all_materials").should == materials_list
    click_link "Assignments"
    page.should have_content "Student View"
    page.should_not have_content "New Assignment"
    click_link "Materials"
    page.should have_content "Student View"
    hash_of("#all_materials").should == materials_list
  end

  scenario "Exiting student view" do
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    click_link "View As Student"
    page.should have_content "Student View"
    hash_of("#all_materials").should == materials_list
    click_link "View As Instructor"
    hash_of("#all_materials").should == materials_list
  end

  scenario "Impersonation isn't visible to students" do
    signin_as :student, courses: [course]
    visit course_path(course)
    click_link "Materials"
    page.should_not have_content "View As Instructor"
    page.should_not have_content "View As Student"
  end
end
