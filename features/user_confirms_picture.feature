Feature: Student authentication
  As a user
  I want others to see an accurate picture of me

  - Require confirmed picture
  - Accept URL or uploaded picture

  Scenario: Student must confirm their photo
    Given the following student:
      | github_uid      | 12345           |
      | email           | joe@example.com |
      | github_username | joe             |
    And I am signed in to Github as "joe"
    When I go to the homepage
    And I follow "Sign In with Github"
    And I go to the homepage
    Then I should see "You must use a real picture."
    And I should not see "This is a picture of me."

  Scenario: Student with confirmed photo doesn't need to confirm
    Given the following student:
      | github_uid      | 12345           |
      | email           | joe@example.com |
      | github_username | joe             |
    And I am signed in to Github as "joe"
    And I have a photo
    And my photo is confirmed
    When I go to the homepage
    And I follow "Sign In with Github"
    And I go to the homepage
    Then I should not see "You must use a real picture."

  Scenario: Student confirms photo
    Given the following student:
      | github_uid      | 12345           |
      | email           | joe@example.com |
      | github_username | joe             |
    And I am signed in to Github as "joe"
    And I have a photo
    When I go to the homepage
    And I follow "Sign In with Github"
    And I go to the homepage
    And I check "This is a picture of me."
    And I press "Submit"
    And I go to the homepage
    Then I should not see "You must use a real picture."
