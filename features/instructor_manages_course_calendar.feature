Feature: Instructor manages course calendar

  @wip
  Scenario: Adding days off
    Given I am signed in as an instructor
    And the following course:
      | title      | Cohort 4   |
      | syllabus   | Foobar     |
      | start_date | 2014/01/24 |
      | end_date   | 2014/03/24 |
    And I am on the course calendar for Cohort 4
    And I click "Add New Event"
    And I select 2014 February 24 from "Event Date"
    And I fill in "Federal Holiday" for "Summary"
    And I press "Create Event"
    Then I should be on the course calendar for Cohort 4
    And I should see the following calendar entries:
      | 2014-02-24 | Federal Holiday |

  Scenario: Viewing course calendar
    Given the following course:
      | title      | Cohort 4   |
      | start_date | 2013/09/12 |
      | end_date   | 2014/01/15 |
    And that course has the following events:
      | date       | summary         |
      | 2013/10/15 | Federal Holiday |
      | 2014/01/10 | No Class        |
    And I am signed in as a student in that course
    When I follow "Course Calendar"
    And I should see the following:
      | October  |
      | November |
      | December |
      | January  |
    Then I should see the following calendar entries:
      | 2013-09-12 | First Day of Class |
      | 2014-01-15 | Last Day of Class  |
      | 2014-01-10 | No Class           |
      | 2013-10-15 | Federal Holiday    |
