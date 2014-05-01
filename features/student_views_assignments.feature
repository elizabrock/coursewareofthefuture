Feature: Student views assignments

  @vcr
  Scenario: Student views an assignment
    Given the following course:
      | title      | Cohort 4   |
      | start_date | 2013/04/28 |
      | end_date   | 2013/06/01 |
    And that it is 2013/05/01
    And I am signed in as a student in that course
    And I have a valid github username
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
    And I should see "Ability to view and submit is pending completion of previous milestones" within the Milestone 2 milestone

  Scenario: Viewing the assignment list only shows published assignments
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

  Scenario: Viewing the assignment list shows the deadlines
    Given the following course:
      | title      | Cohort 4   |
      | start_date | 2013/05/01 |
      | end_date   | 2014/05/01 |
    And that course has the following published assignment:
      | title    | Foobar |
    And that assignment has the following milestones:
      | title       | deadline   | instructions             |
      | Milestone 1 | 2013/05/01 | This milestone is simple |
      | Milestone 2 | 2013/05/15 | This milestone is hard   |
    And I am signed in as a student in that course
    When I go to the homepage
    And I click "Assignments"
    Then I should see "Foobar (5/01 - 5/15)"

  Scenario: Viewing the assignment list prints them in deadline order
    Given the following course:
      | title      | Cohort 4   |
      | start_date | 2012/03/01 |
      | end_date   | 2015/03/01 |
    And that course has the following published assignment:
      | title    | Foobar |
    And that assignment has the following milestones:
      | title       | deadline   | instructions             |
      | Milestone 1 | 2013/05/01 | This milestone is simple |
      | Milestone 2 | 2013/05/15 | This milestone is hard   |
    And that course has the following published assignment:
      | title    | Final |
    And that assignment has the following milestones:
      | title       | deadline   | instructions             |
      | Milestone 1 | 2013/06/01 | This milestone is simple |
    And that course has the following published assignment:
      | title    | Things |
    And that assignment has the following milestones:
      | title       | deadline   | instructions             |
      | Milestone 1 | 2013/05/14 | This milestone is simple |
      | Milestone 2 | 2013/05/31 | This milestone is simple |
    And that course has the following published assignment:
      | title    | BazGrille |
    And that assignment has the following milestones:
      | title       | deadline   | instructions             |
      | Milestone 1 | 2013/04/01 | This milestone is simple |
    And I am signed in as a student in that course
    When I go to the homepage
    And I click "Assignments"
    Then I should see the following list:
      | BazGrille (4/01)     |
      | Foobar (5/01 - 5/15) |
      | Things (5/14 - 5/31) |
      | Final (6/01)         |
