Feature: Instructor grades quizzes

  Background:
    Given the following students:
      | name  |
      | adam  |
      | joe   |
      | jane  |
      | sally |
      | susie |
    And 1 course
    And that course has the following users:
      | name  |
      | joe   |
      | jane  |
      | sally |
      | susie |
    And I am signed in as an instructor for that course
    And that course has the following quiz:
      | title | Checkin |
    And that quiz has the following questions:
      | question_type | question                  | correct_answer              |
      | boolean       | Are you happy?            | true                        |
      | free_text     | What are you happy about? | There is no correct answer. |
      | boolean       | Is class over?            | false                       |
    And that quiz has the following unfinished quiz submissions:
      | user name |
      | susie     |
    And that quiz has the following submitted quiz submissions:
      | user name |
      | jane      |
      | sally     |

  Scenario: Viewing information about a quiz
    When I go to the assignments page
    Then I should see "Checkin Quiz (2 completed, 1 in progress)"
    When I click "Checkin Quiz (2 completed, 1 in progress)"
    Then I should see "susie" within the unfinished quizzes
    And I should see within the submitted quizzes:
      | jane  |
      | sally |
    And I should not see "adam"

  Scenario: Grading by question
    When I go to the assignments page
    And I click "Checkin Quiz (2 completed, 1 in progress)"
    Then I should see:
      | Are you happy? (Automatically Graded)        |
      | What are you happy about? (2 pending grades) |
      | Is class over? (Automatically Graded)        |
    When I click "What are you happy about?"
    Then I should see:
      | jane  |
      | sally |
    And I should not see:
      | adam  |
      | susie |
    When I select "Correct" within the "jane" fieldset
    And I press "Save Grades"
    Then I should see "Grades for 'What are you happy about?' have been updated."
    And I should see:
      | Are you happy? (Automatically Graded)        |
      | What are you happy about? (1 pending grades) |
      | Is class over? (Automatically Graded)        |
    When I click "What are you happy about?"
    Then I should see:
      | jane  |
      | sally |
    And I should not see:
      | adam  |
      | susie |
    And "Correct" should be selected within the "jane" fieldset
    And "" should be selected within the "sally" fieldset
    When I select "Incorrect" within the "sally" fieldset
    And I press "Save Grades"
    Then I should see "Grades for 'What are you happy about?' have been updated."
    And I should see:
      | Are you happy? (Automatically Graded) |
      | What are you happy about? (Graded)    |
      | Is class over? (Automatically Graded) |
    When I click "What are you happy about?"
    Then "Correct" should be selected within the "jane" fieldset
    And "Incorrect" should be selected within the "sally" fieldset
