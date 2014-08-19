require 'rails_helper'

feature "Student views quizzes" do
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


  scenario "not submitted should have 'alert' class" do
    user = signin_as :student, courses: [course]
    click_link "Assignments"
    save_and_open_page
    page.should have_content "Checkin (due"
    page.should have_content "new"
    page.should have_css('.read-status.label.radius.alert.fi-asterisk')
    quiz_submission = Fabricate(:ungraded_quiz_submission, user: user, quiz: quiz)
    populate_quiz_submission(quiz_submission, [ {question: "Are you happy?", answer: "false", score: -1 },
                                                {question: "What are you happy about?", answer: "The food!", score: 0 },
                                                {question: "Is class over?", answer: "false", score: 1 } ])
    click_link "Assignments"
    page.should_not have_css('.read-status.label.radius.alert.fi-asterisk')
    page.should have_css('.read-status.label.radius.secondary.fi-check')
    # page.should have_content "Checkin (submitted for grading)"
    # click_link "Checkin (submitted for grading)"
    # page.should have_content "Checkin (Pending)"
    # page.should have_list ["Are you happy?", "What are you happy about?", "Is class over?"]
    # page.should have_list ["Your Answer: False", "Your Answer: The food!", "Your Answer: False"]
    # page.should_not have_content "Correct Answer"
    # page.should_not have_content "Incorrect"
    # page.should_not have_content "Correct"
  end
end
