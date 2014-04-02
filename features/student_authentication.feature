Feature: Student authentication
  As a student
  I want to be able to sign up/sign in/sign out

  - Standard account creation with OAuth
  - Standard login/logout

  Scenario: Student signs up via. Github
    Given I am signed in to Github as "joe"
    When I go to the homepage
    And I follow "Sign In with Github"
    Then I should see "Successfully authenticated from Github account."
    And I should see "Sign Out"
    And I should not see "Sign In"
    When I follow "Sign Out"
    Then I should not see "Sign Out"
    And I should see "Sign In with Github"
    And I should see the following student in the database:
      | email               | joesmith@example.com                     |
      | github_uid          | 12345                                    |
      | github_username     | joe                                      |
      | name                | Joe Smith                                |
      | github_access_token | d141ef15f79ca4c6f43a8c688e0434648f277f20 |

  Scenario: Student can log in and log out with github
    Given the following student:
      | github_uid      | 12345           |
      | email           | joe@example.com |
      | github_username | joe             |
    And I am signed in to Github as "joe"
    When I go to the homepage
    And I follow "Sign In with Github"
    Then I should see "Successfully authenticated from Github account."
    And I should see "Sign Out"
    And I should not see "Sign In"
    When I follow "Sign Out"
    Then I should not see "Sign Out"
    And I should see "Sign In with Github"

  Scenario: No more sign ups
    When I go to the homepage
    Then I should not see "Sign Up"
