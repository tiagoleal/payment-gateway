require "rails_helper"

RSpec.describe "Login", type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "password") }

  it "logs in successfully" do
    visit new_session_path
    fill_in "Email", with: user.email_address
    fill_in "Password", with: "password"
    click_button "Log in"

    expect(page).to have_content("Logged in successfully!")
  end
end
