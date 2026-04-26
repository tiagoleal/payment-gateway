
Feature: User Login
	As a registered user
	I want to log in
	So that I can access my account

	Scenario: User login successfully
		Given a user exists with email "newuser@example.com" and password "password"
		When I visit the login page
		And I fill in "email_address" with "newuser@example.com"
		And I fill in "password" with "password"
		And I press "Log in"
		Then I should see "Welcome, newuser@example.com"
