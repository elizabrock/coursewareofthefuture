require 'spec_helper'

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
    page.should have_content "Checkin Quiz (2 completed, 1 in progress)"
    click_link "Checkin Quiz (2 completed, 1 in progress)"
    within("#incomplete_quizzes"){ page.should have_content "susie" }
    within("#completed_quizzes"){ page.should have_content "jane" }
    within("#completed_quizzes"){ page.should have_content "sally" }
    page.should_not have_content "adam"
  end

  scenario "Grading by question" do
    visit course_assignments_path(course)
    click_link "Checkin Quiz (2 completed, 1 in progress)"
    page.should have_content("Are you happy? (Automatically Graded)")
    page.should have_content("What are you happy about? (2 pending grades)")
    page.should have_content("Is class over? (Automatically Graded)")
    click_link "What are you happy about?"
    page.should have_content("jane")
    page.should have_content("sally")
    page.should_not have_content("adam")
    page.should_not have_content("susie")
    within_fieldset("jane"){ select "Correct" }
    click_button "Save Grades"
    page.should have_content "Grades for 'What are you happy about?' have been updated."
    page.should have_content("Are you happy? (Automatically Graded)")
    page.should have_content("What are you happy about? (1 pending grades)")
    page.should have_content("Is class over? (Automatically Graded)")
    click_link "What are you happy about?"
    page.should have_content("jane")
    page.should have_content("sally")
    page.should_not have_content("adam")
    page.should_not have_content("susie")
    within_fieldset("jane") do
      find(:option, "Correct").should be_selected
    end
    within_fieldset("sally") do
      find(:option, "").should be_selected
      select "Incorrect"
    end
    click_button "Save Grades"
    page.should have_content "Grades for 'What are you happy about?' have been updated."
    page.should have_content "Are you happy? (Automatically Graded)"
    page.should have_content "What are you happy about? (Graded)"
    page.should have_content "Is class over? (Automatically Graded)"
    click_link "What are you happy about?"
    within_fieldset("jane"){ find(:option, "Correct").should be_selected }
    within_fieldset("sally"){ find(:option, "Incorrect").should be_selected }
  end

  scenario "Finishing grading marks quiz submission as graded" do
    visit course_assignments_path(course)
    click_link "Checkin Quiz (2 completed, 1 in progress)"
    click_link "What are you happy about?"
    within_fieldset("jane"){ select "Correct" }
    # Note that I'm not grading Sally's quiz
    click_button "Save Grades"
    page.should have_content "Grades for 'What are you happy about?' have been updated."
    page.should have_content "Are you happy? (Automatically Graded)"
    page.should have_content "What are you happy about? (1 pending grades)"
    page.should have_content "Is class over? (Automatically Graded)"
    QuizSubmission.where(user: jane, graded: true, grade: 66).count.should == 1
    QuizSubmission.where(user: sally, graded: false).count.should == 1
    click_link "What are you happy about?"
    within_fieldset("jane"){ find(:option, "Correct").should be_selected }
    within_fieldset("sally"){ select "Incorrect" }
    click_button "Save Grades"
    QuizSubmission.where(user: sally, graded: true, grade: 33).count.should == 1
  end

  scenario "Updating question updates grade" do
    QuizSubmission.where(user: jane, graded: false).count.should == 1
    visit course_assignments_path(course)
    click_link "Checkin Quiz (2 completed, 1 in progress)"
    click_link "What are you happy about?"
    within_fieldset("jane"){ select "Correct" }
    click_button "Save Grades"
    page.should have_content "Grades for 'What are you happy about?' have been updated."
    QuizSubmission.where(user: jane, graded: true, grade: 66).count.should == 1
    click_link "What are you happy about?"
    within_fieldset("jane") do
      find(:option, "Correct").should be_selected
      select "Incorrect"
    end
    click_button "Save Grades"
    QuizSubmission.where(user: jane, graded: true, grade: 33).count.should == 1
  end
end
