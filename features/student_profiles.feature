Feature: Student profiles
  As an instructor
  I want my students to have profiles
  So that I can tell them apart

  - profile image (gravatar by default)
  - name
  - email
  - phone number

  Scenario: Student list is not visible to guests
    When I go to the student list page
    Then I should be on the sign in page
    And I should see "You need to sign in or sign up before continuing."

  Scenario: Viewing the student list, as a student
    Given the following students:
      | name       |
      | Jill Smith |
      | Bob Jones  |
    And I am signed in as Jill Smith
    When I go to the student list page
    Then I should see the following list:
      | Bob Jones  |
      | Jill Smith |

  Scenario: Viewing the student list, as an instructor
    Given the following students:
      | name       |
      | Jill Smith |
      | Bob Jones  |
    And I am signed in as an instructor
    When I go to the student list page
    Then I should see the following list:
      | Bob Jones  |
      | Jill Smith |

  Scenario: Viewing a student's profile, as a student
    Given the following students:
      | name       | phone            | email          |
      | Jill Smith | (615) 403 - 5055 | jill@smith.com |
      | Bob Jones  | (858) 205 - 9255 | bob@jones.com  |
    And I am signed in as Jill Smith
    When I go to the student list page
    And I click "Bob Jones"
    Then I should see "(858) 205 - 9255"
    And I should see "bob@jones.com"
    And I should not see "Edit My Profile"

  Scenario: Viewing a student's profile, as an instructor
    Given the following students:
      | name       | phone            | email          |
      | Bob Jones  | (858) 205 - 9255 | bob@jones.com  |
    And I am signed in as an instructor
    When I go to the student list page
    And I click "Bob Jones"
    Then I should see "(858) 205 - 9255"
    And I should see "bob@jones.com"
    And I should not see "Edit My Profile"

  Scenario: Editing my own profile, as a student
    Given the following students:
      | name          |
      | Jillian Smith |
    And I am signed in as Jillian Smith
    When I click "My Profile"
    And I click "Edit My Profile"
    And I fill in "Jill Smith" for "Name"
    And I fill in "jill@smith.com" for "Email"
    And I fill in "(615) 403 - 5055" for "Phone"
    And I fill in "password" for "Current Password"
    And I press "Save Changes"
    Then I should be on my profile page
    And I should see "Your profile has been updated"
    And I should see "Jill Smith"
    And I should see "(615) 403 - 5055"
    And I should see "jill@smith.com"

  Scenario: Changing my email/password
    Given the following students:
      | name       |
      | John Smith |
    And I am signed in as John Smith
    When I follow "My Profile"
    And I click "Edit"
    And I fill in "newemail@example.com" for "Email"
    And I fill in "newpassword" for "Password"
    And I fill in "newpassword" for "Password Confirmation"
    And I fill in "password" for "Current Password"
    And I press "Save Changes"
    Then I should be on my profile page
    And I should see "Your profile has been updated"
    When I click "Sign Out"
    And I follow "Sign In"
    And I fill in "newemail@example.com" for "Email"
    And I fill in "newpassword" for "Password"
    And I press "Sign in"
    Then I should see "Signed in successfully."
