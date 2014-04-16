Feature: True/False questions are graded automatically

  Scenario: True/False Questions are automatically graded
    Given 1 course
    And I am signed in as a student in that course
    And that course has the following quiz:
      | title | Baseline Knowledge Quiz |
    And that quiz has the following questions:
      | question_type | question                  | correct_answer              |
      | boolean       | Are you happy?            | true                        |
      | free_text     | What are you happy about? | There is no correct answer. |
      | boolean       | Is class over?            | false                       |
      | boolean       | Is class in session?      | false                       |
    And I click "Assignments"
    And I click "Baseline Knowledge"
    When I choose "True" for "Are you happy?"
    And I fill in "Everything!" for "What are you happy about?"
    And I choose "True" for "Is class over?"
    And I choose "False" for "Is class in session?"
    And I press "Finish Quiz"
    Then I should see "Your quiz has been submitted for grading."
    And I should be on the assignments page
    And I should see "Baseline Knowledge Quiz (submitted for grading)"
    And the database should have these question answers:
      | source question           | answer      | score |
      | Are you happy?            | true        | 1     |
      | What are you happy about? | Everything! | 0     |
      | Is class over?            | true        | -1    |
      | Is class in session?      | false       | 1     |
