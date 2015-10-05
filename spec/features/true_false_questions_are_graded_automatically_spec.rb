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
    page.find(:xpath, "//div[contains(normalize-space(./label), 'Are you happy?')]//label[contains(text(), 'True')]/input").set(true)
    fill_in "What are you happy about?", with: "Everything!"
    page.find(:xpath, "//div[contains(normalize-space(./label), 'Is class over?')]//label[contains(text(), 'True')]/input").set(true)
    page.find(:xpath, "//div[contains(normalize-space(./label), 'Is class in session?')]//label[contains(text(), 'False')]/input").set(true)
    click_button "Finish Quiz"
    page.should have_content "Your quiz has been submitted for grading."
    current_path.should == course_assignments_path(course)
    page.should have_content "Baseline Knowledge Quiz (submitted for grading)"
    QuestionAnswer.where(question: q1, answer: "true", score: 1).count.should == 1
    QuestionAnswer.where(question: q2, answer: "Everything!", score: 0).count.should == 1
    QuestionAnswer.where(question: q3, answer: "true", score: -1).count.should == 1
    QuestionAnswer.where(question: q4, answer: "false", score: 1).count.should == 1
  end
end
