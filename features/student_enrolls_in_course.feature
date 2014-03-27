Feature: Student enrolls in course

  Background:
    Given the following courses:
      | title     |
      | Cohort 4a |
      | Cohort 4b |
    And the following past courses:
      | title     |
      | Cohort 1a |
      | Cohort 1b |

  Scenario: Enrolling in a course
    Given I am signed in as a student
    When I go to the homepage
    Then I should see "Please select a course below to join it"
    And I should see the following buttons:
      | Join Cohort 4a |
      | Join Cohort 4b |
    And I should not see the following buttons:
      | Join Cohort 1a |
      | Join Cohort 1b |
    When I press "Join Cohort 4a"
    Then I should see "You are now enrolled in Cohort 4a"
    And I should be on the Cohort 4a course page

  Scenario: Signing in or going to the homepage takes you to your course
    Given the following course:
      | title | Cohort 3 |
    And I am signed in as a student in that course
    Then I should be on the Cohort 3 course page
    When I go to the homepage
    Then I should be on the Cohort 3 course page

  Scenario: Signing up for a second course
    Given the following course:
      | title | Cohort 3 |
    And I am signed in as a student in that course
    Then I should be on the Cohort 3 course page
    When I click "Enroll in another course"
    And I should see the following buttons:
      | Join Cohort 4a |
      | Join Cohort 4b |
    And I should not see the following buttons:
      | Join Cohort 1a |
      | Join Cohort 1b |
      | Join Cohort 3  |
    When I press "Join Cohort 4a"
    Then I should see "You are now enrolled in Cohort 4a"
    And I should be on the Cohort 4a course page

  Scenario: Signing up for a second course makes it your default course
    Given the following course:
      | title | Cohort 3 |
    And I am signed in as a student in that course
    Then I should be on the Cohort 3 course page
    When I click "Enroll in another course"
    And I press "Join Cohort 4b"
    Then I should see "You are now enrolled in Cohort 4b"
    And I should be on the Cohort 4b course page
    When I go to the homepage
    Then I should be on the Cohort 4b course page
