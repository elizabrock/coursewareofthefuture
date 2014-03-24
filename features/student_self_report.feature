@wip
Feature: Student Self Report
As a student
I want to see a calendare that allows me to self-report several metrics.

  - self-report form should be available for each day in the past between course start date and end date
  - should see 'today' and other events marked on the calendar
  - should be able to submit a self-report form for a valid reporting day

  Background:
    Given that it is 2013/03/15
    And the following active course:
      | title      | Cohort 4   |
      | start_date | 2013/03/11 |
      | end_date   | 2013/06/20 |
    And that course has the following events:
      | date       | summary         |
      | 2013/03/25 | Federal Holiday |
      | 2013/03/19 | No Class        |
    And I am signed in as a student
    And that student has the following self reports:
      | date       | attended | hours_coding | hours_slept | hours_learning |
      | 2013/03/12 | false    | 5            | 9           | 0              |
      | 2013/03/13 | true     | 2            | 7.5         | 4              |
    And I follow "Course Calendar"

  Scenario: Student sees 'today' in calendar under today's date.
    And show me the page
    Then I should see "Today" within the date 2013-03-15

  Scenario: Student sees a self-report form for days that need missing reports
    Then I should see "Please enter a self-report" within the date 2013-03-14
    And I should see "Please enter a self-report" within the date 2013-03-11
    And I should not see "Please enter a self-report" within the date 2013-03-12
    And I should not see "Please enter a self-report" within the date 2013-03-13
    And I should not see "Please enter a self-report" within the date 2013-03-15

  Scenario: Student sees self-report summary for days that have reports
    Then I should see "Attended class" within the date 2013-03-13
    And I should see "2 hours coding" within the date 2013-03-13
    And I should see "7.5 hours of sleep" within the date 2013-03-13
    And I should see "4 hours of learning" within the date 2013-03-13
    And I should see "Missed class" within the date 2013-03-12
    And I should see "5 hours coding" within the date 2013-03-12
    And I should see "9 hours of sleep" within the date 2013-03-12
    And I should see "0 hours of learning" within the date 2013-03-12

  Scenario: Student enters self-report form
    When I choose "Yes" within the form for 2013-03-14
    And I select "1" from "Hours coding" within the form for 2013-03-14
    And I select "2" from "Hours learning" within the form for 2013-03-14
    And I select "3" from "Hours slept" within the form for 2013-03-14
    And I press "Submit" within the form for 2013-03-14
    Then I should see "Your report has been entered"
    And I should not see "Please enter a self-report" within the date 2013-03-14
    And I should see "Attended class" within the date 2013-03-12
    And I should see "1 hours coding" within the date 2013-03-12
    And I should see "2 hours of sleep" within the date 2013-03-12
    And I should see "3 hours of learning" within the date 2013-03-12
