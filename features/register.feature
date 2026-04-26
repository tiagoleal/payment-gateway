Feature: User Registration
  As a new user
  I want to register
  So that I can access my account

  Scenario: User registers successfully
    Given I am on the registration page
    When I fill in "Name" with "Test User"
    And I fill in "Email" with "newuser@example.com"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Submit"
    Then I should see "Signed up successfully!"

  Scenario: Registration fails without name
    Given I am on the registration page
    And I fill in "Email" with "newuser@example.com"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Submit"
    Then I should see "Name can't be blank"

  Scenario: Registration fails without email
    Given I am on the registration page
    And I fill in "Name" with "Test User"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Submit"
    Then I should see "Email can't be blank"

  Scenario: Registration fails without password
    Given I am on the registration page
    And I fill in "Name" with "Test User"
    And I fill in "Email" with "newuser@example.com"
    And I fill in "Password confirmation" with "password"
    And I press "Submit"
    Then I should see "Password can't be blank"
