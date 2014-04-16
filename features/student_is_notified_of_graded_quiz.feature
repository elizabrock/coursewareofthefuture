Feature: Student is notified of graded quiz

  Background:
    Given 1 course
    And that course has the following quiz:
      | title | Checkin Quiz |
    And that quiz has the following questions:
      | question_type | question                  | correct_answer              |
      | boolean       | Are you happy?            | true                        |
      | free_text     | What are you happy about? | There is no correct answer. |
      | boolean       | Is class over?            | false                       |

  Scenario: Partially graded quiz receives no feedback
    Given I am signed in as a student in that course
    When I have an ungraded quiz submission for that quiz with the following answers:
      | question                  | answer    |
      | Are you happy?            | false     |
      | What are you happy about? | The food! |
      | Is class over?            | false     |
    Then I should receive no email

  Scenario: Graded quiz receives feedback
    Given I am signed in as a student in that course
    And I have an ungraded quiz submission for that quiz with the following answers:
      | question                  | answer    |
      | Are you happy?            | false     |
      | What are you happy about? | The food! |
      | Is class over?            | false     |
    When that quiz is graded
    Then I should receive 1 email
    When I open the email
    Then I should see "Checkin Quiz Graded" in the email subject
    When I follow "View Quiz Feedback" in the email
    And I should see the following list:
      | Are you happy?            | Your Answer: False     | Correct Answer: True                        |
      | What are you happy about? | Your Answer: The food! | Correct Answer: There is no correct answer. |
      | Is class over?            | Your Answer: False     | Correct Answer: False                       |
