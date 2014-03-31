Feature: Student takes quiz

  Background:
    Given 1 course
    And I am signed in as a student in that course
    And that course has the following quiz:
      | title | Baseline Knowledge |
    And that quiz has the following questions:
      | question_type | question                  | correct_answer              |
      | boolean       | Are you happy?            | true                        |
      | free_text     | What are you happy about? | There is no correct answer. |
      | boolean       | Is class over?            | false                       |
    And I click "Assignments"
    And I click "Baseline Knowledge"

  Scenario: Answering some questions without submitting
    When I choose "True" for "Are you happy?"
    And I choose "False" for "Is class over?"
    And I press "Save Progress"
    Then I should see "Your quiz progress has been saved"
    And I should be on the assignments page
    And I should see "Baseline Knowledge Quiz (incomplete, due"
    When I follow "Baseline Knowledge Quiz"
    Then "True" should be choosen for "Are you happy?"
    And "False" should be choosen for "Is class over?"
    And "" should be filled in for "What are you happy about?"

  Scenario: Answering all questions without submitting
    When I choose "True" for "Are you happy?"
    And I fill in "Everything!" for "What are you happy about?"
    And I choose "False" for "Is class over?"
    And I press "Save Progress"
    Then I should see "Your quiz progress has been saved"
    And I should see "Baseline Knowledge Quiz (incomplete, due"

  Scenario: Submitting completed quiz
    When I choose "True" for "Are you happy?"
    And I fill in "Everything!" for "What are you happy about?"
    And I choose "False" for "Is class over?"
    And I press "Finish Quiz"
    Then I should see "Your quiz has been submitted for grading."
    And I should be on the assignments page
    And I should see "Baseline Knowledge Quiz (submitted for grading)"

  Scenario: Student can't submit partial quiz
    When I choose "True" for "Are you happy?"
    And I choose "False" for "Is class over?"
    And I press "Finish Quiz"
    Then I should see "Your quiz cannot yet be submitted for grading"
    And "True" should be choosen for "Are you happy?"
    And "False" should be choosen for "Is class over?"
    And I should see the error message "can't be blank" on "What are you happy about?"
    When I go to the assignments page
    Then I should see "Baseline Knowledge Quiz (incomplete"

  Scenario: Attempting to submit a partial quiz still saves the answers
    When I choose "True" for "Are you happy?"
    And I choose "False" for "Is class over?"
    And I press "Finish Quiz"
    Then I should see "Your quiz cannot yet be submitted for grading"
    When I go to the assignments page
    And I click "Baseline Knowledge Quiz"
    Then "True" should be choosen for "Are you happy?"
    And "False" should be choosen for "Is class over?"
