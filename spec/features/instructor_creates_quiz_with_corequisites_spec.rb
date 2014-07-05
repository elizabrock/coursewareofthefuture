require 'rails_helper'

feature "Instructor creates quiz with corequisites", vcr: true do
  scenario "Happy Path, creating a quiz with corequisites" do
    course = Fabricate(:course,
                        title: "Cohort 4",
                        start_date: "2013/02/28", end_date: "2013/06/01")

    signin_as(:instructor, courses: [course])
    visit new_course_quiz_path(course)
    fill_in "Title", with: "Baseline Knowledge Quiz"
    click_button "Create Quiz"

    page.should have_checkboxes(material_titles)
    check "Logic"
    check "Garbage Collection"
    click_button "Save Changes"

    within("fieldset.corequisites") do
      page.should have_checkboxes(material_titles)
      page.should have_checked_field("Logic")
      page.should have_checked_field("Garbage Collection")
      page.should have_unchecked_field("Truth Tables")
    end

    uncheck "Logic"
    check "Truth Tables"

    fill_in "Deadline", with: "2014/05/14"
    fill_in "Question", with: "Have you installed ruby 2.0?"
    page.select("True/False", from: "Question Type")
    fill_in "Correct Answer", with: "False"
    click_button "Save Changes"
    check "Published"
    click_button "Save Changes"
    page.should have_content "Your quiz has been published"

    click_link "Baseline Knowledge Quiz"
    within(".corequisites") do
      page.should_not have_content("Logic")
      page.should have_content("Garbage Collection")
      page.should have_content("Truth Tables")
      page.should_not have_content("Basic Control Structures")
    end
  end
end
