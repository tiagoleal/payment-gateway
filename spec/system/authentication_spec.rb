# require "rails_helper"

# RSpec.describe "Authentication flow", type: :system do
#   before do
#     driven_by :rack_test # default fast driver; change to selenium for JS
#   end

#   it "allows a user to sign up, login and logout (without JS)" do
#     visit signup_path

#     fill_in "Name", with: user.name
#     fill_in "Email", with: user.email_address
#     fill_in "Password", with: user.password
#     fill_in "Password confirmation", with: user.password_confirmation
#     click_button "Submit"

#     expect(page).to have_text("Signed up successfully!")
#     # expect(page).to have_text("Olá, Test User")

#     # click_link "Logout"
#     # expect(page).to have_text("Logged out.")
#     # expect(page).to have_link("Login")
#     # expect(page).to have_link("Submit")
#   end

#   context "with JS (Turbo + remote forms)" do
#     before do
#       driven_by :selenium_chrome_headless
#     end

#     it "signs up and logs in using turbo frames" do
#       visit signup_path

#       within("#signup_form") do
#         fill_in "Name", with: user.name
#         fill_in "Email", with: user.email_address
#         fill_in "Password", with: user.password
#         fill_in "Password confirmation", with: user.password_confirmation
#         click_button "Submit"
#       end

#       expect(page).to have_text("Signed up successfully!")
#       # expect(page).to have_text("Olá, JS User")

#       # # now logout via turbo delete link
#       # click_link "Logout"
#       # expect(page).to have_text("Logged out.")
#     end
#   end
# end
