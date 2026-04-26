Feature: User Registration and Login
  As a new user
  I want to register and log in
  So that I can access my account

  Scenario: User registers successfully
    Given I am on the registration page
    When I fill in "Name" with "Test User"
    And I fill in "Email" with "newuser@example.com"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Submit"
    Then I should see "Signed up successfully!"

