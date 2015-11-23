require 'rails_helper'

feature "Student marks materials as read", vcr: true do

  scenario "Student marks item as read" do
    course = Fabricate(:course_with_instructor)
    signin_as :student, courses: [course]
    logic = Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/logic.md",
              course: course)
    Fabricate(:covered_material,
              material_fullpath: "computer-science/logic/set_theory.md",
              course: course)

    visit course_path(course)
    click_link "Logic"
    click_link "Mark as Read"
    page.should have_content "Logic has been marked as read."
    current_path.should == course_material_path(course, logic.material_fullpath)
    page.should have_css(".label.read-status", text: "Read")
    click_on "Course Calendar"
    # TODO: Use a more appropriate class for this, instead of a foundation
    # class
    label_for("Logic")["class"].should include("fi-check")
    label_for("Set Theory")["class"].should include("fi-asterisk")

    click_link "Logic"
    page.should_not have_link "Mark as Read"
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

    visit course_path(course2)
    page.should_not have_css(".read-status", text: "Read")

    visit course_path(course1)
    page.should_not have_css(".read-status", text: "Read")
    click_link "Logic"
    click_link "Mark as Read"

    page.should have_css(".label.read-status", text: "Read")
    click_on "Course Calendar"

    # TODO: Use a more appropriate class for this, instead of a foundation
    # class
    label_for("Logic")["class"].should include("fi-check")

    visit course_path(course2)
    # TODO: Use a more appropriate class for this, instead of a foundation
    # class
    label_for("Logic")["class"].should include("fi-check")
  end
end
