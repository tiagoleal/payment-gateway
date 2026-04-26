require 'rails_helper'

RSpec.describe "Clients", type: :request do
  let(:user) { create(:user) }
  let(:client) { create(:client) }

  before do
    post session_path, params: { email_address: user.email_address, password: user.password }
    expect(response).to redirect_to(root_path)
  end

  describe "GET /index" do
    it "returns http success" do
      get clients_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get client_path(client)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_client_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new client and redirects" do
        expect {
          post clients_path, params: { client: attributes_for(:client) }
        }.to change(Client, :count).by(1)
        expect(response).to redirect_to(client_path(Client.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new client and renders new" do
        expect {
          post clients_path, params: { client: { name: "" } }
        }.to_not change(Client, :count)
        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_client_path(client)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the client and redirects" do
        patch client_path(client), params: { client: { name: "New Name" } }
        client.reload
        expect(client.name).to eq("New Name")
        expect(response).to redirect_to(client_path(client))
      end
    end

    context "with invalid parameters" do
      it "does not update the client and renders edit" do
        patch client_path(client), params: { client: { name: "" } }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the client and redirects" do
      client_to_destroy = create(:client)
      expect {
        delete client_path(client_to_destroy)
      }.to change(Client, :count).by(-1)
      expect(response).to redirect_to(clients_path)
    end
  end
end