require 'rails_helper'

feature "Instructor grades quizzes" do

  let(:course){ Fabricate(:course) }
  let!(:joe){ Fabricate(:user, name: "joe", courses: [course]) }
  let!(:jane){ Fabricate(:user, name: "jane", courses: [course]) }
  let!(:sally){ Fabricate(:user, name: "sally", courses: [course]) }
  let!(:susie){ Fabricate(:user, name: "susie", courses: [course]) }

  background do
    signin_as :instructor, courses: [course]
    quiz = Fabricate(:quiz, title: "Checkin Quiz", course: course)
    Fabricate(:question, question_type: "boolean",
              question: "Are you happy?",
              correct_answer: "true", quiz: quiz)
    Fabricate(:question, question_type: "free_text",
              question: "What are you happy about?",
              correct_answer: "There is no correct answer.", quiz: quiz)
    Fabricate(:question, question_type: "boolean",
              question: "Is class over?",
              correct_answer: "false", quiz: quiz)
    Fabricate(:unfinished_quiz_submission, user: susie, quiz: quiz)
    Fabricate(:submitted_quiz_submission, user: jane, quiz: quiz)
    Fabricate(:submitted_quiz_submission, user: sally, quiz: quiz)
  end

  scenario "Viewing information about a quiz" do
    visit course_assignments_path(course)
    expect(page).to have_content "Checkin Quiz (2 completed, 1 in progress)"
    click_link "Checkin Quiz (2 completed, 1 in progress)"
    within("#incomplete_quizzes"){ expect(page).to have_content "susie" }
    within("#completed_quizzes"){ expect(page).to have_content "jane" }
    within("#completed_quizzes"){ expect(page).to have_content "sally" }
    expect(page).not_to have_content "adam"
  end

  scenario "Grading by question" do
    visit course_assignments_path(course)
    click_link "Checkin Quiz (2 completed, 1 in progress)"
    expect(page).to have_content("Are you happy? (Automatically Graded)")
    expect(page).to have_content("What are you happy about? (2 pending grades)")
    expect(page).to have_content("Is class over? (Automatically Graded)")
    click_link "What are you happy about?"
    expect(page).to have_content("jane")
    expect(page).to have_content("sally")
    expect(page).not_to have_content("adam")
    expect(page).not_to have_content("susie")
    within_fieldset("jane"){ select "Correct" }
    click_button "Save Grades"
    expect(page).to have_content "Grades for 'What are you happy about?' have been updated."
    expect(page).to have_content("Are you happy? (Automatically Graded)")
    expect(page).to have_content("What are you happy about? (1 pending grades)")
    expect(page).to have_content("Is class over? (Automatically Graded)")
    click_link "What are you happy about?"
    expect(page).to have_content("jane")
    expect(page).to have_content("sally")
    expect(page).not_to have_content("adam")
    expect(page).not_to have_content("susie")
    within_fieldset("jane") do
      expect(find(:option, "Correct")).to be_selected
    end
    within_fieldset("sally") do
      expect(find(:option, "")).to be_selected
      select "Incorrect"
    end
    click_button "Save Grades"
    expect(page).to have_content "Grades for 'What are you happy about?' have been updated."
    expect(page).to have_content "Are you happy? (Automatically Graded)"
    expect(page).to have_content "What are you happy about? (Graded)"
    expect(page).to have_content "Is class over? (Automatically Graded)"
    click_link "What are you happy about?"
    within_fieldset("jane"){ expect(find(:option, "Correct")).to be_selected }
    within_fieldset("sally"){ expect(find(:option, "Incorrect")).to be_selected }
  end

  scenario "Finishing grading marks quiz submission as graded" do
    visit course_assignments_path(course)
    click_link "Checkin Quiz (2 completed, 1 in progress)"
    click_link "What are you happy about?"
    within_fieldset("jane"){ select "Correct" }
    # Note that I'm not grading Sally's quiz
    click_button "Save Grades"
    expect(page).to have_content "Grades for 'What are you happy about?' have been updated."
    expect(page).to have_content "Are you happy? (Automatically Graded)"
    expect(page).to have_content "What are you happy about? (1 pending grades)"
    expect(page).to have_content "Is class over? (Automatically Graded)"
    expect(QuizSubmission.where(user: jane, graded: true, grade: 66).count).to eql 1
    expect(QuizSubmission.where(user: sally, graded: false).count).to eql 1
    click_link "What are you happy about?"
    within_fieldset("jane"){ expect(find(:option, "Correct")).to be_selected }
    within_fieldset("sally"){ select "Incorrect" }
    click_button "Save Grades"
    expect(QuizSubmission.where(user: sally, graded: true, grade: 33).count).to eql 1
  end

  scenario "Updating question updates grade" do
    expect(QuizSubmission.where(user: jane, graded: false).count).to eql 1
    visit course_assignments_path(course)
    click_link "Checkin Quiz (2 completed, 1 in progress)"
    click_link "What are you happy about?"
    within_fieldset("jane"){ select "Correct" }
    click_button "Save Grades"
    expect(page).to have_content "Grades for 'What are you happy about?' have been updated."
    expect(QuizSubmission.where(user: jane, graded: true, grade: 66).count).to eql 1
    click_link "What are you happy about?"
    within_fieldset("jane") do
      expect(find(:option, "Correct")).to be_selected
      select "Incorrect"
    end
    click_button "Save Grades"
    expect(QuizSubmission.where(user: jane, graded: true, grade: 33).count).to eql 1
  end
end
