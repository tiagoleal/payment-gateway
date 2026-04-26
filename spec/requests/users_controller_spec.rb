require "rails_helper"

RSpec.describe UsersController, type: :request do
  describe "GET /new" do
    it "renders the new template" do
      get new_user_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("name")
    end
  end

  describe "POST /create" do
    let(:user_attrs) { attributes_for(:user_register) }

    let(:invalid_user_attrs) do
      attributes_for(:user_register, name: "", email_address: "", password: "", password_confirmation: "")
    end

    context "HTML format" do
      it "creates a user successfully" do
        expect {
          post users_path, params: { user: user_attrs }
        }.to change(User, :count).by(1)

        expect(session[:user_id]).to eq(User.last.id)
        expect(response).to redirect_to(root_path)

        follow_redirect!
        expect(response.body).to include(I18n.t("auth.signup_success"))
      end

      it "fails with invalid params" do
        expect {
          post users_path, params: { user: invalid_user_attrs }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("error").or include("erro")
      end
    end

    context "Turbo Stream format" do
      it "creates a user and returns turbo stream" do
        expect {
          post users_path,
               params: { user: user_attrs },
               headers: { "Accept" => "text/vnd.turbo-stream.html" }
        }.to change(User, :count).by(1)

        expect(session[:user_id]).to eq(User.last.id)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "fails and re-renders turbo stream errors" do
        expect {
          post users_path,
               params: { user: invalid_user_attrs },
               headers: { "Accept" => "text/vnd.turbo-stream.html" }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("signup_form")
      end
    end
  end
end
