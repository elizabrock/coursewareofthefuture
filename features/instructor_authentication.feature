Feature: Instructor authentication
  As a instructor
  I want to be able to sign in/sign out/reset my password

  - Standard password reset via. email
  - Standard Sign In/Sign Out

  Scenario: Instructor can log in and log out with email
    Given the following instructor:
      | github_username | joe  |
      | github_uid      | 9876 |
    And I am signed in to Github as "joe" with a confirmed photo
    When I go to the homepage
    And I follow "Sign In with Github"
    Then I should see "Successfully authenticated from Github account"
    And I should see "Sign Out"
    And I should not see "Sign In"
    When I follow "Sign Out"
    And I should not see "Sign Out"
    And I should see "Sign In"

  Scenario: Instructor can create another instructor
    Given the following users:
      | name        |
      | Joe Smith   |
      | Sally Myers |
    And I am signed in as an instructor
    And I have a photo
    And my photo is confirmed
    When I go to the homepage
    And I follow "View All Students"
    And I click "Sally Myers"
    And I press "Make Instructor"
    Then I should see "Sally Myers is now an instructor."
    And I should see the following user in the database:
      | name       | Sally Myers |
      | instructor | true        |
    And I should be on the student list page
    And I should see "Sally Myers" within the Instructors section

  Scenario: Student cannot create another instructor
    Given the following users:
      | name        |
      | Joe Smith   |
      | Sally Myers |
    And I am signed in as an instructor
    And I have a photo
    And my photo is confirmed
    When I go to the homepage
    And I follow "View All Students"
    Then I should not see "Make Instructor"
