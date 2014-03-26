Feature: Student profiles
  As an instructor
  I want my students to have profiles
  So that I can tell them apart

  - profile image (gravatar by default)
  - name
  - email
  - phone number
  - goals
  - background

  Background:
    Given the following course:
      | title | Nullth Course |
    And the following course:
      | title | First Course |

  Scenario: Student list is not visible to guests
    When I go to the student list page
    Then I should be on the homepage
    And I should see "You need to sign in or sign up before continuing."

  Scenario: Viewing the student list, as a student
    Given that course has the following students:
      | name       |
      | Jill Smith |
      | Bob Jones  |
    And the following instructors:
      | name        |
      | Julia Child |
    And I am signed in as Jill Smith
    When I go to the homepage
    And I click "Peers"
    Then I should see the following list within the Students section:
      | Bob Jones  |
      | Jill Smith |
    Then I should see the following list within the Instructors section:
      | Julia Child |

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

  Scenario: Viewing the enrollment list, as an instructor
    Given that course has the following students:
      | name  |
      | Sally |
      | Henry |
    And the following students:
      | name       |
      | Jill Smith |
      | Bob Jones  |
    And I am signed in as an instructor
    And I click "First Course"
    And I click "Peers"
    Then I should see the following list:
      | Henry |
      | Sally |
    And I should not see:
      | Bob Jones  |
      | Jill Smith |

  Scenario: Viewing a student's profile, as a student
    Given the following students:
      | name       | phone            | email          | goals                       | background         |
      | Jill Smith | (615) 403 - 5055 | jill@smith.com | I want to learn Javascript. | I know a little C. |
      | Bob Jones  | (858) 205 - 9255 | bob@jones.com  | I want to learn rails.      | I know a little C. |
    And I am signed in as Jill Smith
    When I go to the student list page
    And I click "Bob Jones"
    Then I should see "(858) 205 - 9255"
    And I should see "bob@jones.com"
    And I should not see "I want to learn rails."
    And I should not see "I know a little C."
    And I should not see "Edit My Profile"

  Scenario: Viewing a student's profile, as an instructor
    Given the following students:
      | name       | phone            | email          | goals                  | background         |
      | Bob Jones  | (858) 205 - 9255 | bob@jones.com  | I want to learn rails. | I know a little C. |
    And I am signed in as an instructor
    When I go to the student list page
    And I click "Bob Jones"
    Then I should see "(858) 205 - 9255"
    And I should see "bob@jones.com"
    And I should see "I want to learn rails."
    And I should see "I know a little C."
    And I should not see "Edit My Profile"

  Scenario: Editing my own profile, as an instructor
    Given I am signed in as an instructor
    When I click "My Profile"
    And I click "Edit My Profile"
    And I fill in "Julia Myers" for "Name"
    And I fill in "jill@myers.com" for "Email"
    And I fill in "(615) 403 - 5055" for "Phone"
    And I should not see "Goals"
    And I press "Save Changes"
    Then I should be on my profile page
    And I should see "Your profile has been updated"
    And I should see "Julia Myers"
    And I should see "(615) 403 - 5055"
    And I should see "jill@myers.com"

  Scenario: Editing my own profile, as a student
    Given the following student:
      | name | Jillian Smith |
    And I am signed in as Jillian Smith
    When I click "My Profile"
    And I click "Edit My Profile"
    And I fill in "Jill Smith" for "Name"
    And I fill in "jill@smith.com" for "Email"
    And I fill in "(615) 403 - 5055" for "Phone"
    And I fill in "I want to learn rails." for "Goals"
    And I fill in "I know a little C." for "Background"
    And I press "Save Changes"
    Then I should be on my profile page
    And I should see "Your profile has been updated"
    And I should see "Jill Smith"
    And I should see "(615) 403 - 5055"
    And I should see "jill@smith.com"
    And I should see "I want to learn rails."
    And I should see "I know a little C."

  Scenario: Invalid profile update
    Given the following student:
      | name  | Jillian Smith  |
      | email | jill@smith.com |
    And I am signed in as Jillian Smith
    When I click "My Profile"
    And I click "Edit My Profile"
    And I fill in "jillsmith.com" for "Email"
    And I press "Save Changes"
    Then I should see "must be an email address"
    When I go to my profile page
    Then I should see "jill@smith.com"
    And I should not see "jillsmith.com"
