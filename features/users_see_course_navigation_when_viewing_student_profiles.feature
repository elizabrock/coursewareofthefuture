Feature: Users see course navigation when viewing student profiles

  Background:
    Given the following course:
      | title    | Knitting              |
      | syllabus | Knitting 101 Syllabus |

  Scenario: When you haven't visited the course yet (e.g. direct link)
    Given I am signed in as a student
    And the following student:
      | github_username | ssmith      |
      | name            | Sally Smith |
    When I go to ssmith's profile page
    Then I should see "Sally Smith"
    And I should not see "Materials"
    And I should not see "Calendar"

  Scenario: Navigating to my student profile while looking at a course
    Given I am signed in as a student in that course
    When I click "My Profile"
    Then I should be on my profile page
    And I should see "Materials"
    And I should see "Calendar"
    When I click "Syllabus"
    Then I should see "Knitting 101 Syllabus"

  Scenario: Navigating to my instructor profile while looking at a course
    Given I am signed in as an instructor for that course
    When I click "My Profile"
    Then I should be on my profile page
    And I should see "Materials"
    And I should see "Calendar"
    When I click "Syllabus"
    Then I should see "Knitting 101 Syllabus"

  Scenario: Navigating to my profile from a non-course page (as a student)
    Given I am signed in as a student in that course
    When I click "Enroll in another course"
    When I click "My Profile"
    Then I should be on my profile page
    And I should not see "Materials"
    And I should not see "Calendar"

  Scenario: Navigating to my profile from a non-course page (as an instructor)
    Given I am signed in as an instructor for that course
    When I go to the homepage
    And I click "My Profile"
    Then I should be on my profile page
    And I should not see "Materials"
    And I should not see "Calendar"

  Scenario: When a student navigates to a student via. the peers page
    Given that course has the following students:
      | name       | email          |
      | Joe Smith  | joe@smith.com  |
      | June Smith | june@smith.com |
    And I am signed in as a student in that course
    When I click "Peers"
    And I click "June Smith"
    Then I should see "June Smith"
    And I should see "june@smith.com"
    And I should see "Materials"
    And I should see "Calendar"
    When I click "Syllabus"
    Then I should see "Knitting 101 Syllabus"

  Scenario: When an instructor navigates to a student via. the peers page
    Given that course has the following students:
      | name       | email          |
      | Joe Smith  | joe@smith.com  |
      | June Smith | june@smith.com |
    And I am signed in as an instructor for that course
    When I click "Peers"
    And I click "June Smith"
    Then I should see "June Smith"
    And I should see "june@smith.com"
    And I should see "Materials"
    And I should see "Calendar"
    When I click "Syllabus"
    Then I should see "Knitting 101 Syllabus"

  Scenario: When you've navigated to a student via. the full student list
    Given that course has the following students:
      | name       | email          |
      | Joe Smith  | joe@smith.com  |
      | June Smith | june@smith.com |
    And I am signed in as an instructor for that course
    When I go to the homepage
    And I click "View All Students"
    And I click "June Smith"
    Then I should see "June Smith"
    And I should see "june@smith.com"
