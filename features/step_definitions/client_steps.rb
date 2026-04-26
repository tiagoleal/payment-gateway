require "capybara/rails"
require "capybara/cucumber"

Capybara.default_max_wait_time = 5

Before do
  DatabaseCleaner.clean_with(:truncation)
end

Given("I am logged in") do
  @user = create(:user)
  visit "/session/new"
  fill_in "email_address", with: @user.email_address
  fill_in "password", with: "password"
  click_button "Log in"
end

Given("a client exists with name {string}") do |name|
  @client = create(:client, name: name)
end

When("I visit the new client page") do
  visit "/clients/new"
end

When("I select {string} for {string}") do |value, field|
  select value, from: field
end

Then("I should be on the client page for {string}") do |client_name|
  client = Client.find_by(name: client_name)
  expect(current_path).to match(%r{/clients/#{client.id}})
end

When("I click {string} for client {string}") do |action, client_name|
  client = Client.find_by(name: client_name)

  expect(page).to have_text(client.name)

  row = find("tr[data-testid='client-#{client.id}']")

  if action == "Destroy this client"
    row.find("button[title='#{action}']").click
  else
    row.find("a[title='#{action}']").click
  end
end
