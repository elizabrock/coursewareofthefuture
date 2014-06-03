require 'spec_helper'

feature "Instructor marks materials as covered", vcr: true do

  scenario "Students don't see 'Mark as Covered'" do
    course = Fabricate(:course)
    signin_as :student, courses: [course]
    visit root_path
    click_link "Materials"
    page.should_not have_content "Mark as Covered"
  end

  scenario "Instructor marks item as covered, date defaults to today" do
    Timecop.travel(Time.new(2013, 03, 12))
    course = Fabricate(:course)
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    within("ul#upcoming_materials"){ page.should have_content "Logic" }
    within("ol#covered_materials"){ page.should_not have_content "Logic" }
    mark_as_covered("Logic")
    page.should have_content "logic.md has been marked as covered on 2013/03/12."
    within("ol#covered_materials"){ page.should have_content "Logic" }
    within("ul#upcoming_materials"){ page.should have_content "Covered Logic" }
    mark_as_covered("Basic Control Structures")
    page.should have_content "basic-control-structures.md has been marked as covered on 2013/03/12."
    within("ol#covered_materials") do
      page.should have_list(["Logic", "Basic Control Structures"])
    end
  end

  scenario "Instructor marks item as covered on a particular date" do
    course = Fabricate(:course)
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    within("ul#upcoming_materials"){ page.should have_content "Logic" }
    within("ol#covered_materials"){ page.should_not have_content "Logic" }
    mark_as_covered("Logic", on: "2014/03/12")
    page.should have_content "logic.md has been marked as covered on 2014/03/12."
    within("ol#covered_materials"){ page.should have_content "Logic" }
    within("ul#upcoming_materials"){ page.should have_content "Covered Logic" }
    mark_as_covered("Basic Control Structures", on: "2014/03/12")
    page.should have_content "basic-control-structures.md has been marked as covered"
    within("ol#covered_materials") do
      page.should have_list(["Logic", "Basic Control Structures"])
    end
  end

  scenario "Instructor changes the date an item was covered" do
    Timecop.travel(Time.new(2013, 03, 13))
    course = Fabricate(:course)
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    within("ul#upcoming_materials"){ page.should have_content "Logic" }
    within("ol#covered_materials"){ page.should_not have_content "Logic" }
    mark_as_covered("Logic")
    page.should have_content "logic.md has been marked as covered on 2013/03/13."
    within("ol#covered_materials"){ page.should have_content "Logic" }
    within("ul#upcoming_materials"){ page.should have_content "Covered Logic" }
    Timecop.travel(Time.new(2013, 03, 12))
    click_link "Materials"
    mark_as_covered("Basic Control Structures")
    page.should have_content "basic-control-structures.md has been marked as covered on 2013/03/12."
    within("ol#covered_materials") do
      page.should have_list(["Logic", "Basic Control Structures"])
    end
    mark_as_covered("Logic", on: "2013/03/11")
    page.should have_content "logic.md has been marked as covered on 2013/03/11."
    within("ol#covered_materials") do
      page.should have_list(["Logic", "Basic Control Structures"])
    end
  end

  scenario "Marking an item as covered in one class does not change it's status in other classes" do
    course1 = Fabricate(:course, title: "Javascript")
    course2 = Fabricate(:course, title: "HTML")
    signin_as(:instructor, courses: [course1, course2])
    visit root_path
    click_link "Javascript"
    click_link "Materials"
    within("ul#upcoming_materials"){ page.should have_content "Logic" }
    within("ol#covered_materials"){ page.should_not have_content "Logic" }
    mark_as_covered("Logic")
    page.should have_content "logic.md has been marked as covered"
    within("ul#upcoming_materials"){ page.should have_content "Covered Logic" }
    within("ol#covered_materials"){ page.should have_content "Logic" }
    click_link "HTML"
    click_link "Materials"
    within("ul#upcoming_materials"){ page.should have_content "Logic" }
    within("ol#covered_materials"){ page.should_not have_content "Logic" }
  end
end
