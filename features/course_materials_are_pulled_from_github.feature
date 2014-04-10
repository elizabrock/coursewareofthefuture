@vcr
Feature: Course materials are pulled from github

  Scenario: Viewing the materials list
    Given 1 course
    And I am signed in as an instructor for that course
    When I go to the homepage
    And I click "Materials"
    Then I should not see any of the exercises from Github
    And I should see the materials tree from the inquizator-test-repo

  Scenario: Viewing the materials list
    Given 1 course
    And I am signed in as a student in that course
    When I go to the homepage
    And I click "Materials"
    Then I should not see any of the exercises from Github
    And I should see the materials tree from the inquizator-test-repo with no links

  Scenario: Viewing a single material item
    Given 1 course
    And that course has the following covered material:
      | material_fullpath | materials/computer-science/logic/logic.md |
    And I am signed in as a student in that course
    When I go to the homepage
    And I click "Materials"
    And I click "Logic"
    Then I should see "Logic is, broadly speaking, the application of reasoning to an activity or concept. In Computer Science, we primarily use deductive reasoning (a.k.a. deductive logic) along with boolean algebra (e.g. two-valued logic)."
    And I should see a "h1" tag with the content "Logic"

  Scenario: Viewing an image
    Given 1 course
    And I am signed in as a student in that course
    When I go to the homepage
    When I go to "materials/computer-science/logic/wikimedia-commons-venn-and.png" in that course
    Then I should receive the image "wikimedia-commons-venn-and.png"
