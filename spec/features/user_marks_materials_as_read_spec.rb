require 'rails_helper'

feature "Student marks materials as read", vcr: true do

  scenario "Student marks item as read" do
    course = Fabricate(:course_with_instructor)
    signin_as :student, courses: [course]
    Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/logic.md",
              course: course)
    Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/set_theory.md",
              course: course)

    visit course_materials_path(course)
    click_link "Logic"
    click_link "Mark as Read"
    expect(page).to have_content "Logic has been marked as read."
    expect(current_path).to eql course_materials_path(course)
    within_tr_for("Logic") do
      expect(page).to have_content("read")
    end

    click_link "Logic"
    expect(page).not_to have_link "Mark as Read"
  end

  scenario "Marking an item as read in one class changes it's status in other classes" do
    course1 = Fabricate(:course_with_instructor, title: "Javascript")
    Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/logic.md",
              course: course1)

    course2 = Fabricate(:course, title: "HTML")
    Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/logic.md",
              course: course2)

    signin_as(:student, courses: [course1, course2])

    visit course_materials_path(course2)
    expect(page).not_to have_css(".read-status", text: "Read")

    visit course_materials_path(course1)
    expect(page).not_to have_css(".read-status", text: "Read")
    click_link "Logic"
    click_link "Mark as Read"
    within_tr_for("Logic") do
      expect(page).to have_content("read")
    end

    visit course_materials_path(course2)
    within_tr_for("Logic") do
      expect(page).to have_content("read")
    end
  end
end
