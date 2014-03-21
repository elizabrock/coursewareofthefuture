Feature: Instructor authentication
  As a instructor
  I want to be able to sign in/sign out/reset my password

  - Standard password reset via. email
  - Standard login/logout

  Scenario: Instructor can log in and log out with email
    Given the following instructor:
      | email | joe@example.com |
    When I go to the homepage
    And I follow "Instructor Login"
    And I fill in "joe@example.com" for "Email"
    And I fill in "password" for "Password"
    And I press "Login"
    Then I should see "Signed in successfully."
    And I should see "Logout"
    And I should not see "Login"
    When I follow "Logout"
    And I should not see "Logout"
    And I should see "Login"

  Scenario: Instructor password reset, happy path
    Given the following instructor:
      | email | jil@email.com |
    Given I am on the instructor sign in page
    When I click "Forgot your password?"
    And I fill in "Email" with "jil@email.com"
    And I press "Reset My Password"
    Then "jil@email.com" should receive an email
    When I open the email
    Then I should see "Change my password" in the email body
    When I follow "Change my password" in the email
    Then I should see "Change your password"
    When I fill in "Password" with "secret!!"
    And I fill in "Password confirmation" with "secret!!"
    And I press "Change my password"
    Then I should see "Your password was changed successfully. You are now signed in."
    When I click "Logout"
    And I click "Instructor Login"
    And I fill in "Email" with "jil@email.com"
    And I fill in "Password" with "secret!!"
    And I press "Login"
    Then I should see "Signed in successfully."

  Scenario: Instructor can create another instructor
    Given I am signed in as an instructor
    When I follow "Instructors"
    And I follow "New Instructor"
    And I fill in "joe@example.com" for "Email"
    And I fill in "secret123" for "Password"
    And I fill in "secret123" for "Password confirmation"
    And I press "Create Instructor"
    Then I should see "Instructor was successfully created."
    When I click "Logout"
    And I click "Instructor Login"
    And I fill in "Email" with "joe@example.com"
    And I fill in "Password" with "secret123"
    And I press "Login"
    Then I should see "Signed in successfully."
