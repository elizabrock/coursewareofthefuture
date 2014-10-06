require 'rails_helper'

feature "Student views slides" do

  let(:course){ Fabricate(:course) }
  let!(:covered_material){ Fabricate(:covered_material, material_fullpath: "computer-science/logic/logic.md", course: course) }

  scenario "Student is on materials page and views slides", vcr: true do
    signin_as :student, courses: [course]
    visit course_path(course)
    click_link "Materials"
    click_link "Logic"
    click_link "View As Slides"
    expect(current_path).to eql course_material_slides_path(course, covered_material.fullpath)
  end

  scenario "Instructor is on materials page and views slides", vcr: true do
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    click_link "Logic"
    click_link "View As Slides"
    expect(current_path).to eql course_material_slides_path(course, covered_material.fullpath)
  end

  scenario "Instructor is on materials page and views slides for material that wasn't covered", vcr: true do
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    click_link "Truth Tables"
    click_link "View As Slides"
    expect(current_path).to eql course_material_slides_path(course, "computer-science/logic/truth-tables.md")
  end
end
