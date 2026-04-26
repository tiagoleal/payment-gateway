Given("a user exists with email {string} and password {string}") do |email, password|
  FactoryBot.create(:user, email_address: email, password: password)
end

When("I visit the login page") do
  visit new_session_path
end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end
