require 'rails_helper'

feature "Student marks materials as read", vcr: true do

  scenario "Student marks item as read" do
    course = Fabricate(:course_with_instructor)
    signin_as :student, courses: [course]
    Fabricate(:covered_material,
              material_fullpath: "materials/computer-science/logic/logic.md",
              course: course)
    Fabricate(:covered_material,
              material_fullpath: "materials/computer-science/logic/set_theory.md",
              course: course)

    visit course_materials_path(course)
    click_link "Logic"
    click_button "Mark as Read"
    page.should have_content "Logic has been marked as read."
    current_path.should == course_materials_path(course)
    page.should have_content "Logic (read)"

    click_link "Logic"
    page.should_not have_button "Mark as Read"
  end

  scenario "Marking an item as read in one class changes it's status in other classes" do
    course1 = Fabricate(:course_with_instructor, title: "Javascript")
    Fabricate(:covered_material,
              material_fullpath: "materials/computer-science/logic/logic.md",
              course: course1)

    course2 = Fabricate(:course, title: "HTML")
    Fabricate(:covered_material,
              material_fullpath: "materials/computer-science/logic/logic.md",
              course: course2)

    signin_as(:student, courses: [course1, course2])

    visit course_materials_path(course2)
    page.should_not have_content "Logic (read)"

    visit course_materials_path(course1)
    page.should_not have_content "Logic (read)"
    click_link "Logic"
    click_button "Mark as Read"
    page.should have_content "Logic (read)"

    visit course_materials_path(course2)
    page.should have_content "Logic (read)"
  end
end
