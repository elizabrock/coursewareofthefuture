@wip
Feature: Instructor chooses assignments from github

  Scenario: Happy Path
    Given that I am logged in as an instructor
    When I click "Assignments"
    And I click "New Assignment"
    Then I should see the list of assignments from Github
    When I select "Ruby Koans"
    And I press "Set Milestones"
    Then I should see the following list of milestones:
      | Strings   |
      | Objects   |
      | Triangles |
    When I fill in "3/24/2013" for "Strings Due Date"
    And I fill in "4/28/2013" for "Objects Due Date"
    And I fill in "5/28/2013" for "Triangles Due Date"
    And I press "Publish Assignment"
    Then I should see "Your assignment has been published"
    When I go to the student's assignment list
    Then I should see the following list of milestones:
      | Strings (due 3/24)   |
      | Objects (due 4/28)   |
      | Triangles (due 5/28) |
    When I click "Strings"
    Then I should see the milestone description for Strings
    And I should see "Ability to Submit these is pending"
    # ^ This is temporary, pending the next feature
    When I click "Assignments"
    And I click "Objects"
    Then I should see the milestone description for Objects
    And I should see "Ability to submit is pending completion of previous milestones"
    # ^ This is temporary, pending the next feature

  Scenario: Validations
    Given that this should validate date
    And that this shouldn't show assignments that haven't been published
    Then I should probably test that.
