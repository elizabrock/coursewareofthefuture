require 'rails_helper'

feature "Instructor creates quiz", vcr: true do

  scenario "Creating the initial quiz" do
    signin_as(:instructor, courses: [Fabricate(:course)])
    click_link "Assignments"
    click_link "New Quiz"
    fill_in "Title", with: "Baseline Knowledge Quiz"
    click_button "Create Quiz"
    page.should have_content "Your quiz has been created. Add questions and then publish it."
    click_link "Assignments"
    page.should have_content "Baseline Knowledge Quiz (unpublished)"
  end

  scenario "Free Text Questions" do
    course = Fabricate(:course)
    Fabricate(:unpublished_quiz, title: "Midpoint Checkin", course: course)
    signin_as(:instructor, courses: [course])
    click_link "Assignments"
    click_link "Midpoint Checkin (unpublished)"
    page.should have_content "Add another question"
    fill_in "Question", with: "Have you installed ruby 2.1?"

    page.select("Free Text", from: "Question Type")
    fill_in "Correct Answer", with: "I am a little teapot"
    click_button "Save Changes"
    page.should have_content "Your quiz has been updated."
    within(page.find(:xpath, "//fieldset[position()=2]")) do
     page.should have_content "Have you installed ruby 2.1?"
     page.should have_content "I am a little teapot"
    end
    page.should have_content "Add another question"
    within(page.find(:xpath, "//fieldset[position()=2]")) do
      fill_in "Question", with: "Which ruby version are you running?"
      fill_in "Correct Answer", with: "ruby 2.1.1-p76"
    end
    click_button "Save Changes"
    page.should have_content "Your quiz has been updated"
    within(page.find(:xpath, "//fieldset[position()=2]")) do
      page.should have_content "Which ruby version are you running?"
      page.should have_content "ruby 2.1.1-p76"
    end
    page.should have_content "Add another question"
  end

  scenario "True/False Questions" do
    course = Fabricate(:course)
    Fabricate(:unpublished_quiz, title: "Midpoint Checkin", course: course)
    signin_as(:instructor, courses: [course])
    click_link "Assignments"
    click_link "Midpoint Checkin (unpublished)"
    page.should have_content "Add another question"
    fill_in "Question", with: "Have you installed ruby 2.0?"
    page.select("True/False", from: "Question Type")
    fill_in "Correct Answer", with: "False"
    # TODO: Make a proper selector via. JS:
    # select "False", from: "Correct Answer"
    click_button "Save Changes"
    page.should have_content "Your quiz has been updated"
    within(page.find(:xpath, "//fieldset[position()=2]")) do
      page.should have_content "Have you installed ruby 2.0?"
      page.should have_content "False"
    end
    page.should have_content "Add another question"
    within(page.find(:xpath, "//fieldset[position()=2]")) do
      fill_in "Question", with: "Have you installed ruby 2.1?"
      fill_in "Correct Answer", with: "True"
    end
    # TODO: Make a proper selector via. JS:
    # within(page.find(:xpath, "//fieldset[position()=1]")){ select "True", from: "Correct Answer" }
    click_button "Save Changes"
    page.should have_content "Your quiz has been updated"
    within(page.find(:xpath, "//fieldset[position()=2]")) do
      page.should have_content "Have you installed ruby 2.1?"
      page.should have_content "True"
    end
    page.should have_content "Add another question"
  end

  scenario "Editing quizzes" do
    course = Fabricate(:course)
    signin_as(:instructor, courses: [course])
    quiz = Fabricate(:unpublished_quiz, title: "Final Checkin", course: course)
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
    click_link "Assignments"
    click_link "Final Checkin (unpublished)"
    within(page.find(:xpath, "//fieldset[position()=2]")) do
      fill_in "Question", with: "Are you satisfied?"
    end
    within(page.find(:xpath, "//fieldset[position()=3]")) do
      fill_in "Correct Answer", with: "There can't be a correct answer."
    end
    within(page.find(:xpath, "//fieldset[position()=4]")) do
      fill_in "Correct Answer", with: "True"
    end
    # TODO: Make a proper selector via. JS:
    # within(page.find(:xpath, "//fieldset[position()=3]")){ page.find(:xpath, "//div[contains(normalize-space(./label), '#{"Correct Answer"}')]//label[contains(text(), '#{"true"}')]/input").set(true) }
    click_button "Save Changes"
    page.should have_content "Your quiz has been updated."
    Question.where(question_type: "boolean",
                   question: "Are you satisfied?",
                   correct_answer: "true").count.should == 1
    Question.where(question_type: "free_text",
                   question: "What are you happy about?",
                   correct_answer: "There can't be a correct answer.").count.should == 1
    Question.where(question_type: "boolean",
                   question: "Is class over?",
                   correct_answer: "True").count.should == 1
  end

  scenario "Validations" do
    signin_as(:instructor, courses: [Fabricate(:course)])
    click_link "Assignments"
    click_link "New Quiz"
    fill_in "Title", with: ""
    click_button "Create Quiz"
    page.should have_content "Your quiz could not be saved."
    page.should have_error_message("can't be blank", on: "Title")
    fill_in "Title", with: "The Greatest Quiz Alive"
    click_button "Create Quiz"
    page.should have_content "Your quiz has been created. Add questions and then publish it."
    fill_in "Question", with: ""
    page.select("Free Text", from: "Question Type")
    fill_in "Correct Answer", with: "Blank"
    click_button "Save Changes"
    page.should have_content "Your quiz could not be updated"
    page.should have_error_message("can't be blank", on: "Question")
    find_field("Correct Answer").value.should =~ /#{"Blank"}/

    field_id = find(:field, "Question Type")[:id]
    page.should have_xpath "//select[@id = '#{field_id}']/option[@selected and text() = 'Free Text']"
  end

  scenario "Publishing quizzes" do
    course = Fabricate(:course)
    signin_as(:instructor, courses: [course])
    quiz = Fabricate(:unpublished_quiz, title: "Final Checkin", course: course)
    click_link "Assignments"
    click_link "Final Checkin"
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
    click_link "Assignments"
    click_link "Final Checkin"
    page.should_not have_content "Setting a deadline will publish this quiz."
    fill_in "Deadline", with: "2014/05/14"
    click_button "Save Changes"
    page.should_not have_content "Your quiz has been published."
    visit course_assignments_path(course)
    page.should have_content "Final Checkin (unpublished, due 5/14)"

    click_link "Sign Out"
    signin_as :student, courses: [course]
    click_link "Assignments"
    page.should_not have_content "Final Checkin"

    click_link "Sign Out"
    signin_as :instructor, courses: [course]

    click_link "Assignments"
    click_link "Final Checkin"
    check "Publish"
    click_button "Save Changes"
    page.should have_content "Your quiz has been published."
    page.should have_content "Final Checkin (due 5/14)"

    click_link "Sign Out"
    signin_as :student, courses: [course]
    click_link "Assignments"
    page.should have_content "Final Checkin (due 5/14)"
  end
end
