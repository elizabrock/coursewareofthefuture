@vcr
Feature: Instructor chooses assignments from github

  Scenario: Happy Path, creating an assignment
    Given the following course:
      | title      | Cohort 4   |
      | start_date | 2013/02/28 |
      | end_date   | 2013/06/01 |
    And that course has the following assignment:
      | title | Capstone |
    And that it is 2013/03/01
    And I am signed in as an instructor for that course
    When I click "Assignments"
    And I click "New Assignment"
    Then I should see the following options for "Assignment":
      | Cheers              |
      | Ruby Koans          |
      | Some Other Exercise |
      | Unfinished Exercise |
    When I select "Ruby Koans" for "Assignment"
    And I press "Set Milestones"
    Then I should see the following:
      | Strings   |
      | Objects   |
      | Triangles |
    When I select 2013 March 24 from "Deadline" within the "Strings Milestone" fieldset
    And I select 2013 April 28 from "Deadline" within the "Objects Milestone" fieldset
    And I select 2013 May 28 from "Deadline" within the "Triangles Milestone" fieldset
    And I press "Save Assignment"
    Then I should see "Your assignment has been updated."
    When I click "Assignments"
    Then I should see the following list:
      | Capstone   |
      | Ruby Koans |
    When I click "Ruby Koans"
    Then I should see the following:
      | Strings (due 3/24)   |
      | Objects (due 4/28)   |
      | Triangles (due 5/28) |
    And I should see "Strings are basically arrays." within the Strings milestone
    And I should see "Objects are bloby." within the Objects milestone
    And I should see "Triangles are shapes." within the Triangles milestone

  Scenario: Sad Path, creating an assignment
    Given the following course:
      | title      | Cohort 4   |
      | start_date | 2014/01/16 |
      | end_date   | 2014/02/03 |
    And that it is 2014/02/01
    And I am signed in as an instructor for that course
    When I click "Assignments"
    And I click "New Assignment"
    And I select "Ruby Koans" for "Assignment"
    And I press "Set Milestones"
    Then I should see the following:
      | Strings   |
      | Objects   |
      | Triangles |
    When I select 2013 March 24 from "Deadline" within the "Strings Milestone" fieldset
    And I select 2014 January 28 from "Deadline" within the "Objects Milestone" fieldset
    And I select 2014 May 28 from "Deadline" within the "Triangles Milestone" fieldset
    And I press "Save Assignment"
    Then I should see "Your assignment could not be updated."
    And I should see the error message "Must be in the course timeframe" on "Deadline" within the "Strings Milestone" fieldset
    And 2013 March 24 should be selected for "Deadline" within the "Strings Milestone" fieldset
    And I should see the error message "Must be in the future" on "Deadline" within the "Objects Milestone" fieldset
    And 2014 January 28 should be selected for "Deadline" within the "Objects Milestone" fieldset
    And I should see the error message "Must be in the course timeframe" on "Deadline" within the "Triangles Milestone" fieldset
    And 2013 May 28 should be selected for "Deadline" within the "Triangles Milestone" fieldset
    When I select 2014 February 1 from "Deadline" within the "Strings Milestone" fieldset
    And I select 2014 February 2 from "Deadline" within the "Objects Milestone" fieldset
    And I select 2014 February 3 from "Deadline" within the "Triangles Milestone" fieldset
    And I press "Save Assignment"
    Then I should see "Your assignment has been updated."
    And I should see the following:
      | Strings (due 2/01)   |
      | Objects (due 2/02)   |
      | Triangles (due 2/03) |

  Scenario: Sad path: Exercise that's missing it's innards
    Given the following course:
      | title      | Cohort 4   |
    And that it is 2013/03/01
    And I am signed in as an instructor for that course
    When I click "Assignments"
    And I click "New Assignment"
    Then I should see the following options for "Assignment":
      | Cheers              |
      | Ruby Koans          |
      | Some Other Exercise |
      | Unfinished Exercise |
    When I select "Unfinished Exercise" for "Assignment"
    And I press "Set Milestones"
    Then I should see "Could not retrieve instructions.md in exercises/04-unfinished-exercise. Please confirm that the instructions.md is ready and then try again."

  Scenario: Student views an assignment
    Given the following course:
      | title      | Cohort 4   |
      | start_date | 2013/04/28 |
      | end_date   | 2013/06/01 |
    And that it is 2013/05/01
    And I am signed in as a student in that course
    And that course has the following assignment:
      | title | Capstone |
    And that assignment has the following milestones:
      | title       | deadline   | instructions             |
      | Milestone 1 | 2013/05/01 | This milestone is simple |
      | Milestone 2 | 2013/05/15 | This milestone is hard   |
    When I go to the homepage
    And I click "Assignments"
    And I click "Capstone"
    Then I should see the following:
      | Milestone 1 (due 5/01) |
      | Milestone 2 (due 5/15) |
    And I should see "This milestone is simple" within the Milestone 1 milestone
    And I should see "Ability to submit these is pending" within the Milestone 1 milestone
    # ^ This is temporary, pending the ability to submit milestones
    And I should see "Ability to view and submit is pending completion of previous milestones" within the Milestone 2 milestone
    # ^ This is temporary, pending the ability to submit milestones

  Scenario: Viewing the assignment list
    Given the following course:
      | title | Cohort 4 |
    And that course has the following assignments:
      | title    | published |
      | Foobar   | false     |
      | Capstone | true      |
    And I am signed in as a student in that course
    When I go to the homepage
    And I click "Assignments"
    Then I should see "Capstone"
    And I should not see "Foobar"
