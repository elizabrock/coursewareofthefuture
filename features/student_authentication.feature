Feature: Student authentication
  As a student
  I want to be able to sign up/sign in/sign out

  - Standard email/password signup with email confirmation
  - Standard password reset via. email
  - Standard login/logout

  Scenario: Student signs up with email and password
    When I go to the homepage
    And I follow "Sign Up"
    And I fill in "joe@example.com" for "Email"
    And I fill in "password" for "Password"
    And I fill in "password" for "Password confirmation"
    And I press "Sign up"
    Then I should see "A message with a confirmation link has been sent to your email address."
    And "joe@example.com" should receive an email
    When I open the email
    Then I should see "Confirm my account" in the email body
    When I follow "Confirm my account" in the email
    Then I should see "Your account was successfully confirmed."
    When I fill in "joe@example.com" for "Email"
    And I fill in "password" for "Password"
    And I press "Sign in"
    Then I should see "Signed in successfully."
    And I should see "Sign Out"
    And I should not see "Sign In"
    And I should not see "Sign Up"
    When I follow "Sign Out"
    Then I should not see "Sign Out"
    And I should see "Sign In"

  Scenario: Student can log in and log out with email
    Given the following student:
      | email | joe@example.com |
    When I go to the homepage
    And I follow "Sign In"
    And I fill in "joe@example.com" for "Email"
    And I fill in "password" for "Password"
    And I press "Sign in"
    Then I should see "Signed in successfully."
    And I should see "Sign Out"
    And I should not see "Sign In"
    When I follow "Sign Out"
    And I should not see "Sign Out"
    And I should see "Sign In"

  Scenario: Sending reconfirmation email
    Given the following unconfirmed student:
      | email | joe@example.com |
    And a clear email queue
    When I go to the homepage
    And I follow "Sign In"
    And I fill in "joe@example.com" for "Email"
    And I fill in "password" for "Password"
    And I press "Sign in"
    Then I should see "You have to confirm your account before continuing."
    When I follow "Didn't receive confirmation instructions?"
    And I fill in "joe@example.com" for "Email"
    And I press "Resend confirmation instructions"
    Then "joe@example.com" should receive an email
    When I open the email
    Then I should see "Confirm my account" in the email body
    When I follow "Confirm my account" in the email
    Then I should see "Your account was successfully confirmed."
    When I fill in "joe@example.com" for "Email"
    And I fill in "password" for "Password"
    And I press "Sign in"
    Then I should see "Signed in successfully."
    And I should see "Sign Out"
    And I should not see "Sign In"
    And I should not see "Sign Up"
    When I follow "Sign Out"
    Then I should not see "Sign Out"

  Scenario: Student password reset, happy path
    Given the following student:
      | email | jil@email.com |
    Given I am on the sign in page
    When I click "Forgot your password?"
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
    When I fill in "Email" with "jil@email.com"
    And I fill in "Password" with "secret!!"
    And I press "Sign in"
    Then I should see "Signed in successfully."
