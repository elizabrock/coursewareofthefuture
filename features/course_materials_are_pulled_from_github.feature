Feature: Course materials are pulled from github

  @vcr
  Scenario: Viewing the materials list
    Given 1 active course
    And I am signed in as a student
    When I click "Materials"
    Then I should see the materials tree from the inquizator-test-repo
