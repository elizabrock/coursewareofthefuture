require 'rails_helper'

feature "Student views quiz feedback" do

  let(:course){ Fabricate(:course) }
  let(:quiz){ Fabricate(:quiz, title: "Checkin", course: course) }

  background do
    Fabricate(:question,
              question_type: "boolean",
              question: "Are you happy?",
              correct_answer: "true", quiz: quiz)
    Fabricate(:question,
              question_type: "free_text",
              question: "What are you happy about?",
              correct_answer: "There is no correct answer.", quiz: quiz)
    Fabricate(:question,
              question_type: "boolean",
              question: "Is class over?",
              correct_answer: "false", quiz: quiz)
  end

  scenario "Viewing feedback shows feedback on each question" do
    user = signin_as :student, courses: [course]
    quiz_submission = Fabricate(:graded_quiz_submission, user: user, quiz: quiz)
    populate_quiz_submission(quiz_submission, [ {question: "Are you happy?", answer: "false", score: -1 },
                                                {question: "What are you happy about?", answer: "The food!", score: 1 },
                                                {question: "Is class over?", answer: "false", score: 1 } ])
    click_link "Assignments"
    page.should have_content "Checkin (66%)"
    click_link "Checkin (66%)"
    page.should have_content "Checkin (66%)"
    page.should have_list ["Are you happy?", "What are you happy about?", "Is class over?"]
    page.should have_list ["Your Answer: False", "Your Answer: The food!", "Your Answer: False"]
    page.should have_list ["Correct Answer: True", "Correct Answer: There is no correct answer.", "Correct Answer: False"]
    page.should have_list ["Incorrect", "Correct", "Correct"]
  end

  scenario "Incompletely graded quizzes show no feedback" do
    user = signin_as :student, courses: [course]
    quiz_submission = Fabricate(:ungraded_quiz_submission, user: user, quiz: quiz)
    populate_quiz_submission(quiz_submission, [ {question: "Are you happy?", answer: "false", score: -1 },
                                                {question: "What are you happy about?", answer: "The food!", score: 0 },
                                                {question: "Is class over?", answer: "false", score: 1 } ])
    click_link "Assignments"
    page.should have_content "Checkin (submitted for grading)"
    click_link "Checkin (submitted for grading)"
    page.should have_content "Checkin (Pending)"
    page.should have_list ["Are you happy?", "What are you happy about?", "Is class over?"]
    page.should have_list ["Your Answer: False", "Your Answer: The food!", "Your Answer: False"]
    page.should_not have_content "Correct Answer"
    page.should_not have_content "Incorrect"
    page.should_not have_content "Correct"
  end
end
