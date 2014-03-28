@vcr
Feature: Switching between courses

  Background:
    Given that it is 2013/03/24
    And the following course:
      | title             | Front-End Development            |
      | source_repository | elizabrock/NSS-Syllabus-Cohort-3 |
      | start_date        | 2014/03/20                       |
      | end_date          | 2014/06/20                       |
      | syllabus          | Zed Double You                   |
    And that course has the following events:
      | date       | summary     |
      | 2014/03/25 | Day Off     |
      | 2014/03/26 | Not Day Off |
    And that course has the following students:
      | name |
      | Jim  |
      | Joe  |
    And the following course:
      | title             | Software Development Fundamentals |
      | source_repository | elizabrock/inquizator-test-repo   |
      | start_date        | 2014/02/20                        |
      | end_date          | 2014/05/20                        |
      | syllabus          | Foo Bar                           |
    And that course has the following events:
      | date       | summary              |
      | 2014/03/15 | Grinchmas            |
      | 2014/03/29 | Airing of Grievances |
    And that course has the following students:
      | name  |
      | Susie |
      | Sally |
    And the following courses:
      | title         | start_date | end_date   |
      | Past Course   | 2012/01/01 | 2012/04/01 |
      | Future Course | 2014/05/06 | 2014/06/07 |

  Scenario: Instructor Chooses Course
    Given I am signed in as an instructor
    And I have a photo
    And my photo is confirmed
    When I go to the homepage
    Then I should see "Which course are you teaching today?"
    And I should see the following list:
      | Front-End Development             |
      | Software Development Fundamentals |
      | Future Course                     |
    And I should not see "Past Course"
    When I click "Software Development Fundamentals"
    Then I should see "Foo Bar"
    When I click "Syllabus"
    Then I should see "Foo Bar"
    When I click "Peers"
    Then I should see the following list:
      | Sally |
      | Susie |
    And I should not see:
      | Jim |
      | Joe |
    When I click "Materials"
    Then I should see "Computer Science"
    And I should not see "Unit 1"
    When I click "Course Calendar"
    Then I should see "Grinchmas"
    And I should not see "Day Off"
    When I follow "Front-End Development"
    Then I should see "Zed Double You"
    When I click "Syllabus"
    Then I should see "Zed Double You"
    When I click "Peers"
    Then I should see:
      | Jim |
      | Joe |
    And I should not see:
      | Susie |
      | Sally |
    When I click "Materials"
    Then I should see "Unit1"
    And I should not see "Computer Science"
    When I click "Course Calendar"
    Then I should see "Day Off"
    And I should not see "Grinchmas"
