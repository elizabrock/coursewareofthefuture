Feature: Instructor authentication
  As a instructor
  I want to be able to sign in/sign out/reset my password

  - Standard password reset via. email
  - Standard login/logout

  Scenario: Instructor can log in and log out with email
    Given the following instructor:
      | email | joe@example.com |
    When I go to the homepage
    And I follow "Sign In"
    And I follow "Instructor Sign In"
    And I fill in "joe@example.com" for "Email"
    And I fill in "password" for "Password"
    And I press "Sign in"
    Then I should see "Signed in successfully."
    And I should see "Sign Out"
    And I should not see "Sign In"
    When I follow "Sign Out"
    And I should not see "Sign Out"
    And I should see "Sign In"

  Scenario: Instructor password reset, happy path
    Given the following instructor:
      | email | jil@email.com |
    Given I am on the sign in page
    And I follow "Instructor Sign In"
    When I click "Forgot your instructor password?"
    And I fill in "Email" with "jil@email.com"
    And I press "Send me reset password instructions"
    Then "jil@email.com" should receive an email
    When I open the email
    Then I should see "Change my password" in the email body
    When I follow "Change my password" in the email
    Then I should see "Change your password"
    When I fill in "New password" with "secret!!"
    And I fill in "Confirm new password" with "secret!!"
    And I press "Change my password"
    Then I should see "Your password was changed successfully. You are now signed in."
    When I click "Sign Out"
    Then I should see "Sign In"
    When I click "Sign In"
    And I follow "Instructor Sign In"
    And I fill in "Email" with "jil@email.com"
    And I fill in "Password" with "secret!!"
    And I press "Sign in"
    Then I should see "Signed in successfully."
