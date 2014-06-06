require 'spec_helper'

feature "Student views slides" do

  scenario "Student is on materials page and views slides", vcr: true do
    course = Fabricate(:course)
    covered_material = Fabricate(:covered_material, material_fullpath: "materials/computer-science/logic/logic.md", course: course)
    signin_as :student, courses: [course]
    visit root_path
    click_link "Materials"
    click_link "Logic"
    click_link "View As Slides"
    current_path.should == slides_course_covered_material_path(course, covered_material)
  end

end
