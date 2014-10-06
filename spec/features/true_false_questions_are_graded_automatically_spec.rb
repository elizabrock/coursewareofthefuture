require 'rails_helper'

feature "True/False questions are graded automatically" do

  scenario "True/False Questions are automatically graded" do
    course = Fabricate(:course)
    signin_as :student, courses: [course]
    quiz = Fabricate(:quiz, title: "Baseline Knowledge Quiz", course: course)
    q1 = Fabricate(:question, question_type: "boolean", question: "Are you happy?", correct_answer: "true", quiz: quiz)
    q2 = Fabricate(:question, question_type: "free_text", question: "What are you happy about?", correct_answer: "There is no correct answer.", quiz: quiz)
    q3 = Fabricate(:question, question_type: "boolean", question: "Is class over?", correct_answer: "false", quiz: quiz)
    q4 = Fabricate(:question, question_type: "boolean", question: "Is class in session?", correct_answer: "false", quiz: quiz)
    click_link "Assignments"
    click_link "Baseline Knowledge"
    page.find(:xpath, "//div[contains(normalize-space(.), 'Are you happy?')]/label[contains(text(), 'True')]/input").set(true)
    fill_in "What are you happy about?", with: "Everything!"
    page.find(:xpath, "//div[contains(normalize-space(.), 'Is class over?')]/label[contains(text(), 'True')]/input").set(true)
    page.find(:xpath, "//div[contains(normalize-space(.), 'Is class in session?')]/label[contains(text(), 'False')]/input").set(true)
    click_button "Finish Quiz"
    expect(page).to have_content "Your quiz has been submitted for grading."
    expect(current_path).to eql course_assignments_path(course)
    expect(page).to have_content "Baseline Knowledge Quiz (submitted for grading)"
    expect(QuestionAnswer.where(question: q1, answer: "true", score: 1).count).to eql 1
    expect(QuestionAnswer.where(question: q2, answer: "Everything!", score: 0).count).to eql 1
    expect(QuestionAnswer.where(question: q3, answer: "true", score: -1).count).to eql 1
    expect(QuestionAnswer.where(question: q4, answer: "false", score: 1).count).to eql 1
  end
end
