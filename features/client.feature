Feature: Client Management
  As a user
  I want to manage clients
  So that I can keep track of my customers

  Scenario: User creates a new client
    Given I am logged in
    When I visit the new client page
    And I fill in "client_name" with "John Doe"
    And I fill in "client_due_day" with "15"
    And I select "Credit Card" for "client_payment_method_identifier"
    And I press "Create Client"
    Then I should see "Client was successfully created."
    And I should be on the client page for "John Doe"