require 'rails_helper'

feature "Student views quizzes" do
  let(:course){ Fabricate(:course) }
  let(:quiz){ Fabricate(:quiz, title: "Checkin", course: course) }

  background do
    user = signin_as(:student, courses: [course])
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
    Fabricate(:quiz_submission, user: user, quiz: quiz)
    Fabricate(:quiz, title: "Pop Quiz", course: course)
  end

  scenario "Unsubmitted quiz has 'alert' css" do
    visit course_calendar_path course
    find(:link, "Pop Quiz Due").find(:xpath, "..")[:class].should include('alert')
  end

  scenario "Submitted milestone does not have 'alert' css" do
    visit course_calendar_path course
    find(:link, "Checkin Due").find(:xpath, "..")[:class].should_not include('alert')
  end

end
