require 'rails_helper'

feature "Student views slides" do

  let(:course){ Fabricate(:course) }
  let!(:covered_material){ Fabricate(:covered_material, material_fullpath: "materials/computer-science/logic/logic.md", course: course) }

  scenario "Student is on materials page and views slides", vcr: true do
    signin_as :student, courses: [course]
    visit course_path(course)
    click_link "Materials"
    click_link "Logic"
    click_link "View As Slides"
    current_path.should == slides_course_covered_material_path(course, covered_material)
  end

  scenario "Instructor is on materials page and views slides", vcr: true do
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    click_link "Logic"
    click_link "View As Slides"
    current_path.should == slides_course_covered_material_path(course, covered_material)
  end
end
