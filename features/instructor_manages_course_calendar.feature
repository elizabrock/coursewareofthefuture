Feature: Instructor manages course calendar

  @wip
  Scenario: Adding days off
    Given I am signed in as an instructor
    When I follow "Course"
    And I follow "New Course"
    And I fill in "Title" with "Cohort 4"
    And I fill in "Syllabus" with "Foobar"
    And I select 2014 January 24 from "course_start_date"
    And I select 2014 March 24 from "course_end_date"
    And I check "Active course"
    And I press "Create Course"
    Then I should see "Course was successfully created"

  Scenario: Viewing course calendar
    Given the following active course:
      | title      | Cohort 4   |
      | start_date | 2013/09/12 |
      | end_date   | 2014/01/15 |
    And that course has the following events:
      | date       | summary         |
      | 2013/10/15 | Federal Holiday |
      | 2014/01/10 | No Class        |
    And I am signed in as a student
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
