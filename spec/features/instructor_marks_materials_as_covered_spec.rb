require 'rails_helper'

feature "Instructor marks materials as covered", vcr: true do

  scenario "Students don't see 'Mark as Covered'" do
    course = Fabricate(:course)
    signin_as :student, courses: [course]
    visit root_path
    click_link "Materials"
    page.should_not have_content "Mark as Covered"
  end

  scenario "Instructor marks item as covered, date defaults to today" do
    Timecop.travel(Time.new(2013, 03, 12)) do
      course = Fabricate(:course)
      signin_as :instructor, courses: [course]
      visit course_path(course)
      click_link "Materials"
      within_tr_for("Logic"){ page.should_not have_content("Covered") }
      mark_as_covered("Logic")
      page.should have_content "Logic has been marked as covered on 3/12."
      within_tr_for("Logic"){ page.should have_content("Covered") }
      mark_as_covered("Basic Control Structures")
      page.should have_content "Basic Control Structures has been marked as covered on 3/12."
      within_tr_for("Logic"){ page.should have_content("Covered") }
      within_tr_for("Basic Control Structures"){ page.should have_content("Covered") }
    end
  end

  scenario "Instructor marks item as covered on a particular date" do
    course = Fabricate(:course)
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    within_tr_for("Logic"){ page.should_not have_content("Covered") }
    mark_as_covered("Logic", on: "2014/03/12")
    page.should have_content "Logic has been marked as covered on 3/12."
    within_tr_for("Logic"){ page.should have_content("Covered") }
    mark_as_covered("Basic Control Structures", on: "2014/03/12")
    page.should have_content "Basic Control Structures has been marked as covered"
    within_tr_for("Logic"){ page.should have_content("Covered") }
    within_tr_for("Basic Control Structures"){ page.should have_content("Covered") }
  end

  scenario "Instructor changes the date an item was covered" do
    Timecop.travel(Time.new(2013, 03, 13)) do
      course = Fabricate(:course)
      signin_as :instructor, courses: [course]
      visit course_path(course)
      click_link "Materials"
      within_tr_for("Logic") do
        page.should_not have_content "Covered"
      end
      mark_as_covered("Logic")
      page.should have_content "Logic has been marked as covered on 3/13."
      within_tr_for("Logic") do
        page.should have_content "Covered 3/13"
      end
    end

    Timecop.travel(Time.new(2013, 03, 12)) do
      click_link "Materials"
      mark_as_covered("Basic Control Structures")
      page.should have_content "Basic Control Structures has been marked as covered on 3/12."
      within_tr_for("Logic"){ page.should have_content("Covered") }
      within_tr_for("Basic Control Structures"){ page.should have_content("Covered") }
      mark_as_covered("Logic", on: "2013/03/11")
      page.should have_content "Logic has been marked as covered on 3/11."
      within_tr_for("Logic"){ page.should have_content("Covered") }
      within_tr_for("Basic Control Structures"){ page.should have_content("Covered") }
    end
  end

  scenario "Marking an item as covered in one class does not change it's status in other classes" do
    course1 = Fabricate(:course, title: "Javascript")
    course2 = Fabricate(:course, title: "HTML")
    signin_as(:instructor, courses: [course1, course2])

    visit root_path
    click_link "Javascript"
    click_link "Materials"

    within_tr_for("Logic"){ page.should_not have_content("Covered") }
    mark_as_covered("Logic")
    page.should have_content "Logic has been marked as covered"
    within_tr_for("Logic"){ page.should have_content("Covered") }

    click_link "Materials"
    within_tr_for("Logic"){ page.should have_content("Covered") }

    click_link "HTML"
    click_link "Materials"
    within_tr_for("Logic"){ page.should_not have_content("Covered") }
  end
end
