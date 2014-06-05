require 'spec_helper'

feature "Student views slides" do

  scenario "Student is on materials page and views slides", vcr: true do
    Timecop.travel(Time.new(2013, 03, 12))
    course = Fabricate(:course)
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    mark_as_covered("Logic")
    page.should have_content "logic.md has been marked as covered on 2013/03/12."

    signin_as :student, courses: [course]
    visit root_path
    click_link "Materials"
    click_link "Logic"
    click_link "View As Slides"
    covered_material = CoveredMaterial.all.find(1)
    current_path.should == slides_course_covered_material_path(course, covered_material)
  end

end
