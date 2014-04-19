@vcr
Feature: Instructor marks materials as covered

  Scenario: Students don't see "Mark as Covered"
    Given 1 course
    And I am signed in as a student in that course
    And I go to the homepage
    When I click "Materials"
    Then I should not see "Mark as Covered"

  Scenario: Instructor marks item as covered, date defaults to today
    Given that it is 2013/03/12
    And 1 course
    And I am signed in as an instructor for that course
    When I click "Materials"
    Then I should see "Logic" within the materials to cover
    And I should not see "Logic" within the materials that have been covered
    When I mark "Logic" as covered
    Then I should see "logic.md has been marked as covered on 2013/03/12."
    And I should see "Logic" within the materials that have been covered
    And I should see "Covered Logic" within the materials to cover
    When I mark "Basic Control Structures" as covered
    Then I should see "basic-control-structures.md has been marked as covered on 2013/03/12."
    And I should see the following list within the materials that have been covered:
      | Logic                    |
      | Basic Control Structures |

  Scenario: Instructor marks item as covered on a particular date
    Given 1 course
    And I am signed in as an instructor for that course
    When I click "Materials"
    Then I should see "Logic" within the materials to cover
    And I should not see "Logic" within the materials that have been covered
    When I mark "Logic" as covered on 2014/03/12
    Then I should see "logic.md has been marked as covered on 2014/03/12."
    And I should see "Logic" within the materials that have been covered
    And I should see "Covered Logic" within the materials to cover
    When I mark "Basic Control Structures" as covered on 2014/03/12
    Then I should see "basic-control-structures.md has been marked as covered"
    And I should see the following list within the materials that have been covered:
      | Logic                    |
      | Basic Control Structures |

  Scenario: Instructor changes the date an item was covered
    Given that it is 2013/03/13
    And 1 course
    And I am signed in as an instructor for that course
    When I click "Materials"
    Then I should see "Logic" within the materials to cover
    And I should not see "Logic" within the materials that have been covered
    When I mark "Logic" as covered
    Then I should see "logic.md has been marked as covered on 2013/03/13."
    And I should see "Logic" within the materials that have been covered
    And I should see "Covered Logic" within the materials to cover
    Given that it is 2013/03/12
    When I click "Materials"
    And I mark "Basic Control Structures" as covered
    Then I should see "basic-control-structures.md has been marked as covered on 2013/03/12."
    And I should see the following list within the materials that have been covered:
      | Basic Control Structures |
      | Logic                    |
    When I mark "Logic" as covered on "2013/03/11"
    Then I should see "logic.md has been marked as covered on 2013/03/11."
    And I should see the following list within the materials that have been covered:
      | Logic                    |
      | Basic Control Structures |

  Scenario: Marking an item as covered in one class does not change it's status in other classes
    Given the following courses:
      | title      |
      | Javascript |
      | HTML       |
    And I am signed in as an instructor for those courses
    When I click "Javascript"
    And I click "Materials"
    Then I should see "Logic" within the materials to cover
    And I should not see "Logic" within the materials that have been covered
    When I mark "Logic" as covered
    Then I should see "logic.md has been marked as covered"
    And I should see "Covered Logic" within the materials to cover
    And I should see "Logic" within the materials that have been covered
    When I click "HTML"
    And I click "Materials"
    Then I should see "Logic" within the materials to cover
    And I should not see "Logic" within the materials that have been covered
