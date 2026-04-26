Before do
  I18n.locale = :en
end

Given("I am on the registration page") do
  visit new_user_path
end

