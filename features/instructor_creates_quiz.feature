Feature: Instructor creates quiz

  Scenario: Creating the initial quiz
    Given I am signed in as an instructor for a course
    When I click "Assignments"
    And I click "New Quiz"
    And I fill in "Title" with "Baseline Knowledge"
    And I press "Create Quiz"
    Then I should see "Your quiz has been created. Add questions and then publish it."
    When I click "Assignments"
    Then I should see "Baseline Knowledge Quiz (Unpublished)"

  Scenario: Free Text Questions
    Given 1 course
    And that course has the following quiz:
      | title | Midpoint Checkin |
    And I am signed in as the instructor for that course
    When I click "Assignments"
    And I click "Midpoint Checkin Quiz (Unpublished)"
    Then I should see "Add another question"
    When I fill in "Question" with "Have you installed ruby 2.1?"
    And I select "Free Text" from "Question Type"
    And I fill in "Correct Answer" with "I am a little teapot"
    And I press "Save Changes"
    Then I should see "Your quiz has been updated."
    And I should see "Have you installed ruby 2.1?" within Q1
    And I should see "I am a little teapot" within Q1
    And I should see "Add another question"
    When I fill in "Question" with "Which ruby version are you running?" within Q1
    And I fill in "Correct Answer" with "ruby 2.1.1-p76" within Q1
    And I press "Save Changes"
    Then I should see "Your quiz has been updated"
    And I should see "Which ruby version are you running?" within Q1
    And I should see "ruby 2.1.1-p76" within Q1
    And I should see "Add another question"

  Scenario: True/False Questions
    Given 1 course
    And that course has the following quiz:
      | title | Midpoint Checkin |
    And I am signed in as the instructor for that course
    When I click "Assignments"
    And I click "Midpoint Checkin Quiz (Unpublished)"
    Then I should see "Add another question"
    When I fill in "Question" with "Have you installed ruby 2.0?"
    And I select "True/False" from "Question Type"
    And I fill in "False" for "Correct Answer"
    # TODO: Make a proper selector via. JS:
    # And I select "False" for "Correct Answer"
    And I press "Save Changes"
    Then I should see "Your quiz has been updated"
    And I should see "Have you installed ruby 2.0?" within Q1
    And I should see "False" within Q1
    And I should see "Add another question"
    When I fill in "Question" with "Have you installed ruby 2.1?" within Q1
    And I fill in "True" for "Correct Answer" within Q1
    # TODO: Make a proper selector via. JS:
    # And I select "True" for "Correct Answer" within Q1
    And I press "Save Changes"
    Then I should see "Your quiz has been updated"
    And I should see "Have you installed ruby 2.1?" within Q1
    And I should see "True" within Q1
    And I should see "Add another question"

  Scenario: Editing quizzes
    Given 1 course
    And I am signed in as the instructor for that course
    And that course has the following quiz:
      | title | Final Checkin |
    And that quiz has the following questions:
      | question_type | question                  | correct_answer              |
      | boolean       | Are you happy?            | true                        |
      | free_text     | What are you happy about? | There is no correct answer. |
      | boolean       | Is class over?            | false                       |
    When I click "Assignments"
    And I click "Final Checkin Quiz (Unpublished)"
    And I fill in "Are you satisfied?" for "Question" within Q1
    And I fill in "There can't be a correct answer." for "Correct Answer" within Q2
    And I fill in "True" for "Correct Answer" within Q3
    # TODO: Make a proper selector via. JS:
    # And I choose "true" for "Correct Answer" within Q3
    And I press "Save Changes"
    Then I should see "Your quiz has been updated."
    Then the database should have these questions:
      | question_type | question                  | correct_answer                   |
      | boolean       | Are you satisfied?        | true                             |
      | free_text     | What are you happy about? | There can't be a correct answer. |
      | boolean       | Is class over?            | True                             |

  Scenario: Validations
    Given I am signed in as an instructor for a course
    When I click "Assignments"
    And I click "New Quiz"
    And I fill in "Title" with ""
    And I press "Create Quiz"
    Then I should see "Your quiz could not be saved."
    And I should see the error message "can't be blank" on "Title"
    And I fill in "Title" with "The Greatest Quiz Alive"
    And I press "Create Quiz"
    Then I should see "Your quiz has been created. Add questions and then publish it."
    When I fill in "Question" with ""
    And I select "Free Text" from "Question Type"
    And I fill in "Correct Answer" with "Blank"
    And I press "Save Changes"
    Then I should see "Your quiz could not be updated"
    And I should see the error message "can't be blank" on "Question"
    And "Blank" should be filled in for "Correct Answer"
    And "Free Text" should be selected for "Question Type"

  Scenario: Publishing quizzes
    Given 1 course
    And I am signed in as the instructor for that course
    And that course has the following quiz:
      | title | Final Checkin |
    When I click "Assignments"
    And I click "Final Checkin"
    Then I should not see "Deadline"
    Given that quiz has the following questions:
      | question_type | question                  | correct_answer              |
      | boolean       | Are you happy?            | true                        |
      | free_text     | What are you happy about? | There is no correct answer. |
      | boolean       | Is class over?            | false                       |
    When I click "Assignments"
    And I click "Final Checkin"
    Then I should see "Setting a deadline will publish this quiz. Format must be YYYY/MM/DD"
    When I fill in "2014/05/14" for "Deadline"
    And I press "Save Changes"
    Then I should see "Your quiz has been published."
    And I should see "Final Checkin Quiz (due 5/14)"
    When I sign out
    And sign in as a student in that course
    And I click "Assignments"
    Then I should see "Final Checkin Quiz (due 5/14)"
