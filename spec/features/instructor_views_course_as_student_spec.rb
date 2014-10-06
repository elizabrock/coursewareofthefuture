require 'rails_helper'

feature "Instructor views course as student", vcr: true do

  let!(:course){ Fabricate(:course) }

  scenario "Mimicking a student preserves the view across page loads" do
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    expect(hash_of("#all_materials")).to eql materials_list
    click_link "View As Student"
    expect(page).to have_content "Student View"
    expect(hash_of("#all_materials")).to eql materials_list
    click_link "Assignments"
    expect(page).to have_content "Student View"
    expect(page).not_to have_content "New Assignment"
    click_link "Materials"
    expect(page).to have_content "Student View"
    expect(hash_of("#all_materials")).to eql materials_list
  end

  scenario "Exiting student view" do
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    click_link "View As Student"
    expect(page).to have_content "Student View"
    expect(hash_of("#all_materials")).to eql materials_list
    click_link "View As Instructor"
    expect(hash_of("#all_materials")).to eql materials_list
  end

  scenario "Impersonation isn't visible to students" do
    signin_as :student, courses: [course]
    visit course_path(course)
    click_link "Materials"
    expect(page).not_to have_content "View As Instructor"
    expect(page).not_to have_content "View As Student"
  end
end
