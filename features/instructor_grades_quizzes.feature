@wip
Feature: Instructor grades quizzes

  Background:
    Given the following users:
      | name  |
      | adam  |
      | joe   |
      | jane  |
      | sally |
      | susie |
    And 1 course
    And I am signed in as an instructor for that course
    And the following quiz:
      | title | Checkin |
    And that quiz has the following questions:
      | question_type | question                  | correct_answer              |
      | boolean       | Are you happy?            | true                        |
      | free_text     | What are you happy about? | There is no correct answer. |
      | boolean       | Is class over?            | false                       |
    And that course has the following users:
      | name  |
      | joe   |
      | jane  |
      | sally |
      | susie |
    And that quiz has the following unfinished quiz submissions:
      | user name |
      | susie     |
    And that quiz has the following submitted quiz submissions:
      | user name |
      | jane      |
      | sally     |

  Scenario: Viewing information about a quiz
    When I go to the assignments page
    Then I should see "Checkin Quiz (2 ready to grade, 1 in progress)"
    When I click "Checkin Quiz"
    Then I should see "Susie" within the unfinished quizzes
    And I should see within the submitted quizzes:
      | jane  |
      | sally |
    And I should not see "adam"

  Scenario: Grading by question
    When I go to the assignments page
    And I click "Checkin Quiz"
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
    When I choose "Correct" for "jane"
    And I press "Save Grades"
    Then I should see:
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
    When I choose "Incorrect" for "sally"
    And I press "Save Grades"
    Then I should see:
      | Are you happy? (Automatically Graded) |
      | What are you happy about? (Graded)    |
      | Is class over? (Automatically Graded) |
    And the database should have these question answers:
      | user name | score |
      | jane      | 0     |
      | susie     | 1     |
      | sally     | -1    |
