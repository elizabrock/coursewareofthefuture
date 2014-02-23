Feature: Instructor manages courses

  Scenario: Creating a course
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

  Scenario: Only the information for the active course is shown to students
    Given the following inactive courses:
      | title    |
      | Cohort 3 |
      | Cohort 5 |
    Given the following active course:
      | title | Cohort 4 |
    And I am signed in as a student
    When I go to the homepage
    Then I should see "Cohort 4"

  Scenario: Students see markdown formatted syllabus
    Given the following course:
      | title    | Cohort 4           |
      | syllabus | This is *awesome*. |
    And I am signed in as a student
    When I go to the homepage
    Then I should see a "em" tag with the content "awesome"
