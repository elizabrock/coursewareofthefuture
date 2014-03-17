Feature: Student Self Report
As a student

I want to enter a self-report form for each day in the past between course start date and end date.

  @focus
  Scenario: Student sees 'today' in calendar under today's date.
    Given it is currently '2014-03-17'
    Given the following student:
      | email | joe@example.com |
     Given the following active course:
      | title      | Cohort 4   |
      | start_date | 2014/03/12 |
      | end_date   | 2014/06/20 |
    And that course has the following events:
      | date       | summary         |
      | 2014/03/25 | Federal Holiday |
      | 2014/03/20 | No Class        |
      | 2014-03-17 | Today           |
    And I am signed in as a student
    And I follow "Course Calendar"
    Then I should see "Sun"
    And I should see "Today"
