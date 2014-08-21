require 'rails_helper'

feature "Student marks material as 'read'", vcr: true do

  let(:student) { Fabricate(:student) }

  scenario "read material has 'alert' class" do
    course1 = Fabricate(:course_with_instructor, title: "Javascript")
    Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/logic.md",
              course: course1)
    signin_as(:student, courses: [course1])
    visit course_calendar_path(course1)
    find(:link, "Logic Covered").find(:xpath, "..")[:class].should include('alert')
    click_link "Logic Covered"
    click_link "Mark as Read"
    visit course_calendar_path(course1)
    find(:link, "Logic Covered").find(:xpath, "..")[:class].should_not include('alert')
  end

end
