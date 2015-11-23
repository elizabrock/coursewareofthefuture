require 'rails_helper'

feature "Student takes quiz" do

  let(:course){ Fabricate(:course) }

  background do
    signin_as :student, courses: [course]
    quiz = Fabricate(:quiz, title: "Baseline Knowledge", course: course)
    Fabricate(:question, question_type: "boolean", question: "Are you happy?", correct_answer: "true", quiz: quiz)
    Fabricate(:question, question_type: "free_text", question: "What are you happy about?", correct_answer: "There is no correct answer.", quiz: quiz)
    Fabricate(:question, question_type: "boolean", question: "Is class over?", correct_answer: "false", quiz: quiz)
    click_link "Assignments"
    click_link "Baseline Knowledge"
  end

  scenario "Answering some questions without submitting" do
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Are you happy?"}')]//label[contains(text(), '#{"True"}')]/input").set(true)
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Is class over?"}')]//label[contains(text(), '#{"False"}')]/input").set(true)
    click_button "Save Progress"
    page.should have_content "Your quiz progress has been saved"
    current_path.should == course_assignments_path(course)
    page.should have_content "Baseline Knowledge (incomplete, due"
    click_link "Baseline Knowledge"
    within(div_labeled("Are you happy?")){ page.should have_checked_field("True") }
    within(div_labeled("Is class over?")){ page.should have_checked_field("False") }
    find_field("What are you happy about?").value.should =~ /#{""}/
  end

  scenario "Answering all questions without submitting" do
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Are you happy?"}')]//label[contains(text(), '#{"True"}')]/input").set(true)
    fill_in "What are you happy about?", with: "Everything!"
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Is class over?"}')]//label[contains(text(), '#{"False"}')]/input").set(true)
    click_button "Save Progress"
    page.should have_content "Your quiz progress has been saved"
    page.should have_content "Baseline Knowledge (incomplete, due"
  end

  scenario "Submitting completed quiz" do
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Are you happy?"}')]//label[contains(text(), '#{"True"}')]/input").set(true)
    fill_in "What are you happy about?", with: "Everything!"
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Is class over?"}')]//label[contains(text(), '#{"False"}')]/input").set(true)
    click_button "Finish Quiz"
    page.should have_content "Your quiz has been submitted for grading."
    current_path.should == course_assignments_path(course)
    page.should have_content "Baseline Knowledge (submitted for grading)"
  end

  scenario "Student can't submit partial quiz" do
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Are you happy?"}')]//label[contains(text(), '#{"True"}')]/input").set(true)
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Is class over?"}')]//label[contains(text(), '#{"False"}')]/input").set(true)
    click_button "Finish Quiz"
    page.should have_content "Your quiz cannot yet be submitted for grading"
    within(div_labeled("Are you happy?")){ page.should have_checked_field("True") }
    within(div_labeled("Is class over?")){ page.should have_checked_field("False") }
    page.should have_error_message("can't be blank", on: "What are you happy about?")
    visit course_assignments_path(course)
    page.should have_content "Baseline Knowledge (incomplete"
  end

  scenario "Attempting to submit a partial quiz still saves the answers" do
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Are you happy?"}')]//label[contains(text(), '#{"True"}')]/input").set(true)
    page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Is class over?"}')]//label[contains(text(), '#{"False"}')]/input").set(true)
    click_button "Finish Quiz"
    page.should have_content "Your quiz cannot yet be submitted for grading"
    visit course_assignments_path(course)
    click_link "Baseline Knowledge"
    within(div_labeled("Are you happy?")){ page.should have_checked_field("True") }
    within(div_labeled("Is class over?")){ page.should have_checked_field("False") }
  end
end
