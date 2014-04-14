Feature: Student views quiz feedback

  Background:
    Given 1 course
    And that course has the following quiz:
      | title | Checkin |
    And that quiz has the following questions:
      | question_type | question                  | correct_answer              |
      | boolean       | Are you happy?            | true                        |
      | free_text     | What are you happy about? | There is no correct answer. |
      | boolean       | Is class over?            | false                       |

  Scenario: Viewing feedback shows feedback on each question
    Given I am signed in as a student in that course
    And I have a graded quiz submission for that quiz with the following answers:
      | question                  | answer    | score |
      | Are you happy?            | false     | -1    |
      | What are you happy about? | The food! | 1     |
      | Is class over?            | false     | 1     |
    When I click "Assignments"
    Then I should see "Checkin Quiz (66%)"
    When I click "Checkin Quiz (66%)"
    Then I should see "Result: 66%"
    And I should see the following list:
      | Are you happy?            | Your Answer: False     | Correct Answer: True                        | Incorrect |
      | What are you happy about? | Your Answer: The food! | Correct Answer: There is no correct answer. | Correct   |
      | Is class over?            | Your Answer: False     | Correct Answer: False                       | Correct   |

  Scenario: Incompletely graded quizzes show no feedback
    Given I am signed in as a student in that course
    And I have an ungraded quiz submission for that quiz with the following answers:
      | question                  | answer    | score |
      | Are you happy?            | false     | -1    |
      | What are you happy about? | The food! | 0     |
      | Is class over?            | false     | 1     |
    When I click "Assignments"
    Then I should see "Checkin Quiz (submitted for grading)"
    When I click "Checkin Quiz (submitted for grading)"
    Then I should see "Result: Pending"
    And I should see the following list:
      | Are you happy?            | Your Answer: False     |
      | What are you happy about? | Your Answer: The food! |
      | Is class over?            | Your Answer: False     |
    And I should not see "Correct Answer"
    And I should not see "Incorrect"
    And I should not see "Correct"
