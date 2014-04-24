@vcr
Feature: Student submits milestone

  Background:
    Given that it is 2013/05/01
    And 1 course
    And that course has the following student:
      | name                | Eliza                                    |
      | github_username     | elizabrock                               |
      | github_access_token | d141ef15f79ca4c6f43a8c688e0434648f277f20 |
    And I am signed in as Eliza
    And that course has the following assignment:
      | title | Capstone |
    And that assignment has the following milestones:
      | title       | deadline   | instructions             |
      | Milestone 1 | 2013/05/01 | This milestone is simple |
      | Milestone 2 | 2013/05/15 | This milestone is hard   |
    When I go to the homepage
    And I click "Assignments"
    And I click "Capstone"

  Scenario: Submitting milestone, happy path
    # This is not ideal, since it will change when Eliza has more public repos.
    # However, the effort required to set up a proper test user doesn't seem warranted yet.
    Then I should see the following options for "Assignment Repository":
      |                                 |
      | coursewareofthefuture           |
      | coveralls-ruby                  |
      | deadsets                        |
      | fabrication                     |
      | FuturePerfect                   |
      | inquizator-test-repo            |
      | Intro-to-Rails-3-Presentation   |
      | LaTeX-Resume                    |
      | linked_list_cohort3             |
      | linked_list_cohort_tangerine    |
      | monologue                       |
      | NSS-basic-rails-blog            |
      | nss-cal                         |
      | nss-capstone-2-example          |
      | NSS-CLI-test-example            |
      | NSS-futureperfect-CLI           |
      | NSS-futureperfect-rails         |
      | NSS-Ruby-Koans                  |
      | nss-squawker                    |
      | NSS-Syllabus-Cohort-3           |
      | NSS-Syllabus-Fall-2012          |
      | NSS-Syllabus-Spring-2013        |
      | NSS-Test-Repo                   |
      | presentation_nashville_hack_day |
      | slide-em-up                     |
      | software-development-curriculum |
      | tapestry                        |
      | testing_cheers                  |
      | tr3w-conversion                 |
      | wedding                         |
    And I should not see "This milestone is hard"
    When I select "software-development-curriculum" from "Assignment Repository"
    And I press "Submit Milestone" within the Milestone 1 milestone
    Then I should see "Milestone 1 has been submitted for grading"
    And I should see "Status: Submitted for Grading" within the Milestone 1 milestone
    # And I should see "Assignment Repository: elizabrock/software-development-curriculum"
    And I should see "This milestone is hard"
    When I select "software-development-curriculum" from "Assignment Repository"
    And I press "Submit Milestone" within the Milestone 2 milestone
    Then I should see "Milestone 2 has been submitted for grading"
    And I should see "Status: Submitted for Grading" within the Milestone 1 milestone
    And I should see "Status: Submitted for Grading" within the Milestone 2 milestone

  @wip
  Scenario: Student has no public repos?

  @wip
  Scenario: Resubmitting Milestone

  @wip
  Scenario: User can't submit milestone for a course they aren't enrolled in
