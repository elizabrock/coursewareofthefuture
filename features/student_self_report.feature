@javascript

Feature: Student Self Report
As a student
I want to see a calendare that allows me to self-report several metrics.

  - self-report form should be available for each day in the past between course start date and end date
  - should see 'today' and other events marked on the calendar
  - should be able to submit a self-report form for a valid reporting day

  Background:
    Given that it is 2013/03/15
    And the following course:
      | title      | Cohort 4   |
      | start_date | 2013/03/11 |
      | end_date   | 2013/06/20 |
    And that course has the following events:
      | date       | summary         |
      | 2013/03/25 | Federal Holiday |
      | 2013/03/19 | No Class        |
    And that course has the following user:
      | name | joe |
    And that user has the following self reports:
      | date       | attended | hours_coding | hours_slept | hours_learning |
      | 2013/03/12 | false    | 5            | 9           | 0              |
      | 2013/03/13 | true     | 2            | 7.5         | 4              |
    And I am signed in as joe
    And I go to the homepage
    And I follow "Course Calendar"

  Scenario: Student sees 'today' in calendar under today's date.
    Then I should see "Today" within the date 2013-03-15

  Scenario: Student sees a self-report form for days that need missing reports
    Then I should see "Self-Report:" within the date 2013-03-14
    And I should see "Self-Report:" within the date 2013-03-11
    And I should see "Self-Report:" within the date 2013-03-15
    And I should not see "Self-Report:" within the date 2013-03-12
    And I should not see "Self-Report:" within the date 2013-03-13

  Scenario: Student still sees self-report form is another user has filled out their own report
    Given 1 student
    And that user has the following self reports:
      | date       | attended | hours_coding | hours_slept | hours_learning |
      | 2013/03/11 | false    | 5            | 9           | 0              |
    When I follow "Course Calendar"
    Then I should see "Self-Report:" within the date 2013-03-11

  Scenario: Student does not see self-report form for days before the class
    Then I should not see "Self-Report:" within the date 2013-03-01
    And I should not see "Self-Report:" within the date 2013-03-10
    And I should not see "Self-Report:" within the date 2013-03-09

  Scenario: Student sees self-report summary for days that have reports
    Then I should see "Class: Attended" within the date 2013-03-13
    And I should see "Coding: 2 hours" within the date 2013-03-13
    And I should see "Sleep: 7.5 hours" within the date 2013-03-13
    And I should see "Learning: 4 hours" within the date 2013-03-13
    And I should see "Class: Missed" within the date 2013-03-12
    And I should see "Coding: 5 hours" within the date 2013-03-12
    And I should see "Sleep: 9 hours" within the date 2013-03-12
    And I should see "Learning: 0 hours" within the date 2013-03-12

  Scenario: Student enters self-report form
    Then I should see "Self-Report:" within the date 2013-03-14
    When I choose "Yes" within the date 2013-03-14
    And I select "1" from "Hours coding" within the date 2013-03-14
    And I select "2" from "Hours learning" within the date 2013-03-14
    And I select "3" from "Hours slept" within the date 2013-03-14
    And I press "Submit" within the date 2013-03-14
    And I should not see "Self-Report:" within the date 2013-03-14
    And I should see "Class: Attended" within the date 2013-03-14
    And I should see "Coding: 1 hours" within the date 2013-03-14
    And I should see "Learning: 2 hours" within the date 2013-03-14
    And I should see "Sleep: 3 hours" within the date 2013-03-14
