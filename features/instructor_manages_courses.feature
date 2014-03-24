Feature: Instructor manages courses

  @wip
  Scenario: Creating a course
    Given I am signed in as an instructor
    When I follow "Create New Course"
    And I fill in "Title" with "Cohort 4"
    And I fill in "Syllabus" with "Foobar"
    And I select 2014 January 24 from "Start Date"
    And I select 2014 March 24 from "End Date"
    And I press "Create Course"
    Then I should see "Course was successfully created"
    And I should see the following course in the database:
      | title         | Cohort 4   |
      | syllabus      | Foobar     |
      | start_date    | 2014/01/24 |
      | end_date      | 2014/03/24 |

  Scenario: Only the information for the active course is shown to students
    Given that it is 2013/02/24
    Given the following courses:
      | title    | end_date   |
      | Cohort 3 | 2013/01/14 |
      | Cohort 4 | 2014/02/28 |
      | Cohort 5 | 2014/04/14 |
    And I am signed in as a student
    When I go to the homepage
    Then I should see:
      | Join Cohort 4 |
      | Join Cohort 5 |

  Scenario: Students see markdown formatted syllabus
    Given the following course:
      | title    | Cohort 4           |
      | syllabus | This is *awesome*. |
    And I am signed in as a student in that course
    When I go to the homepage
    Then I should see a "em" tag with the content "awesome"
