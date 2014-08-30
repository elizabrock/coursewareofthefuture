require 'rails_helper'

feature "Student is notified of graded quiz" do

  let(:course){ Fabricate(:course) }
  let(:quiz){ Fabricate(:quiz, title: "Checkin Quiz", course: course) }

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

  scenario "Partially graded quiz receives no feedback" do
    user = signin_as :student, courses: [course]
    quiz_submission = Fabricate(:ungraded_quiz_submission, user: user, quiz: quiz)
    populate_quiz_submission(quiz_submission, [ {question: "Are you happy?", answer: "false" },
                                                {question: "What are you happy about?", answer: "The food!" },
                                                {question: "Is class over?", answer: "false" } ])
    expect(unread_emails_for(user.email).size).to eql 0
  end

  scenario "Graded quiz receives feedback" do
    user = signin_as :student, courses: [course]
    quiz_submission = Fabricate(:ungraded_quiz_submission, user: user, quiz: quiz)
    populate_quiz_submission(quiz_submission, [ {question: "Are you happy?", answer: "false" },
                                                {question: "What are you happy about?", answer: "The food!" },
                                                {question: "Is class over?", answer: "false" } ])


    # This grades that quiz.  So, we're testing what happens once that quiz is graded:
    quiz_submission.submit!
    quiz_submission.question_answers.each do |answer|
      if answer.ungraded?
        answer.score = [-1, 1].sample
        answer.save
      end
    end
    expect(quiz_submission).to be_graded

    expect(unread_emails_for(user.email).size).to eql 1
    open_email(user.email)
    expect(current_email).to have_subject "Checkin Quiz Graded"
    visit_in_email /View Quiz Feedback/
    expect(page).to have_list ["Are you happy?", "What are you happy about?", "Is class over?"]
    expect(page).to have_list ["Your Answer: False", "Your Answer: The food!", "Your Answer: False"]
    expect(page).to have_list ["Correct Answer: True", "Correct Answer: There is no correct answer.", "Correct Answer: False"]
  end
end
