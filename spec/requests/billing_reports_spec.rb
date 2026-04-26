require 'rails_helper'

RSpec.describe "BillingReports", type: :request do
  let(:user) { create(:user) }

  before do
    post session_path, params: { email_address: user.email_address, password: "password" }
  end

  describe "GET /index" do
    it "returns http success" do
      get "/billing_reports/index"
      expect(response).to have_http_status(:success)
    end
  end
end
