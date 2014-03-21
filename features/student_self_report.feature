@wip
Feature: Student Self Report
As a student
I want to see a calendare that allows me to self-report several metrics.

  - self-report form should be available for each day in the past between course start date and end date
  - should see 'today' and other events marked on the calendar
  - should be able to submit a self-report form for a valid reporting day

  Background:
    Given the following student:
      | email | joe@example.com |
    Given the following active course:
      | title      | Cohort 4   |
      | start_date | 2014/03/12 |
      | end_date   | 2014/06/20 |
    And that course has the following events:
      | date                          | summary         |
      | 2014/03/25                    | Federal Holiday |
      | 2014/03/19                    | No Class        |
      | Time.now.strftime("%Y-%m-%d") | Today           |
    And I am signed in as a student
    And I follow "Course Calendar"

  Scenario: Student sees 'today' in calendar under today's date.
    Then I should see "Sun"
    And I should see "Today"

  Scenario: Student sees a self-report form
    Then I should see a "label" tag with the content "Attended class"
    And I should see a "label" tag with the content "Hours coding"
    And I should see a "label" tag with the content "Hours learning"
    And I should see a "label" tag with the content "Hours slept"

  Scenario: Student enters self-report form
    When I choose "Yes" within the form for 2014-03-19
    And I select "1" from "self_report_hours_coding" within the form for 2014-03-19
    And I select "2" from "self_report_hours_learning" within the form for 2014-03-19
    And I select "3" from "self_report_hours_slept" within the form for 2014-03-19
    And I press "Submit" within the form for 2014-03-19
    Then I should not see "that specific 'submit' button"
