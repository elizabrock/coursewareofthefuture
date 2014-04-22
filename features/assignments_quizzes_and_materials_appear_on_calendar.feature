Feature: Assignments quizzes and materials appear on calendar

  Background:
    Given the following course:
      | title      | Cohort N   |
      | start_date | 2014/01/01 |
      | end_date   | 2014/02/01 |
    And I am signed in as a student in that course

  Scenario: Assignments
    Given that course has the following unpublished assignment:
      | title | Unpublished Assignment |
    And that assignment has the following milestones:
      | title | deadline   |
      | Pt. n | 2014/01/03 |
    And that course has the following published assignment:
      | title | Koans |
    And that assignment has the following milestones:
      | title | deadline   |
      | Pt. 1 | 2014/01/02 |
      | Pt. 2 | 2014/01/04 |
    When I go to the homepage
    And I follow "Course Calendar"
    Then I should see the following calendar entries:
      | 2014-01-02 | Koans: Pt. 1 Due |
      | 2014-01-04 | Koans: Pt. 2 Due |
    And I should not see "Unpublished Assignment"
    And I should not see "Pt. n"

  Scenario: Quizzes
    Given that course has the following quizzes:
      | title              | deadline   |
      | Baseline Knowledge | 2014/01/01 |
      | Midpoint Checkin   | 2014/01/15 |
    When I go to the homepage
    And I follow "Course Calendar"
    Then I should see the following calendar entries:
      | 2014-01-01 | Baseline Knowledge Due |
      | 2014-01-15 | Midpoint Checkin Due   |

  Scenario: Covered Materials
    Given that course has the following covered materials:
      | material_fullpath                              | covered on |
      | materials/computer-science/logic/logic.md      | 2014/01/15 |
      | materials/computer-science/logic/set_theory.md | 2014/01/20 |
    When I go to the homepage
    And I follow "Course Calendar"
    Then I should see the following calendar entries:
      | 2014-01-15 | Logic      |
      | 2014-01-20 | Set Theory |
