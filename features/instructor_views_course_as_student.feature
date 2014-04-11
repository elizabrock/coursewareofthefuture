@vcr
Feature: Instructor views course as student

  Background:
    Given 1 course

  Scenario: Mimicking a student preserves the view across page loads
    Given I am signed in as an instructor for that course
    When I click "Materials"
    Then I should see the materials tree from the inquizator-test-repo with links
    When I click "View As Student"
    Then I should see "Student View"
    And I should see the materials tree from the inquizator-test-repo with no links
    When I click "Assignments"
    Then I should see "Student View"
    And I should not see "New Assignment"
    When I click "Materials"
    Then I should see "Student View"
    And I should see the materials tree from the inquizator-test-repo with no links

  Scenario: Exiting student view
    Given I am signed in as an instructor for that course
    When I click "Materials"
    And I click "View As Student"
    Then I should see "Student View"
    And I should see the materials tree from the inquizator-test-repo with no links
    When I click "View As Instructor"
    Then I should see the materials tree from the inquizator-test-repo with links

  Scenario: Impersonation isn't visible to students
    Given I am signed in as a student in that course
    When I click "Materials"
    Then I should not see "View As Instructor"
    And I should not see "View As Student"
