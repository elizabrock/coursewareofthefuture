@vcr
Feature: Course materials are pulled from github

  Scenario: Viewing the materials list
    Given 1 course
    And I am signed in as a student in that course
    When I click "Materials"
    Then I should not see any of the exercises from Github
    And I should see the materials tree from the inquizator-test-repo

  Scenario: Viewing a single material item
    Given 1 course
    And I am signed in as a student in that course
    When I click "Materials"
    And I click "Logic"
    Then I should see "Logic is, broadly speaking, the application of reasoning to an activity or concept. In Computer Science, we primarily use deductive reasoning (a.k.a. deductive logic) along with boolean algebra (e.g. two-valued logic)."
    And I should see a "h1" tag with the content "Logic"
