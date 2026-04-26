require "rails_helper"

RSpec.describe SessionsController, type: :request do
  describe "GET /new" do
    it "renders the new session template" do
      get new_session_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    let(:user) { FactoryBot.create(:user, password: "password") }

    context "with valid credentials" do
      it "logs in the user and redirects to after_authentication_url" do
        post session_path, params: { email_address: user.email_address, password: "password" }
        expect(response).to redirect_to(root_path)
        get response.redirect_url

        expect(response).to redirect_to(dashboard_path)
        follow_redirect!
        expect(response.body).to include("Dashboard")
      end
    end

    context "with invalid credentials" do
      it "does not log in the user and redirects to new_session_path with an alert" do
        post session_path, params: { email_address: user.email_address, password: "wrong_password" }
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(new_session_path(locale: I18n.locale))
        follow_redirect!
        expect(response.body).to include("Try another email address or password.")
      end
    end
  end

  describe "DELETE /destroy" do
    let(:user) { FactoryBot.create(:user, password: "password") }

    before do
      post session_path, params: { email_address: user.email_address, password: "password" }
    end

    it "logs out the user and redirects to new_session_path" do
      delete session_path
      expect(response).to redirect_to(new_session_path(locale: I18n.locale))
    end
  end
end
