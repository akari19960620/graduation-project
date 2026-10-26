require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/users/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post "/users", params: {
        user: {
          name: "テストユーザー",
          email: "testtest@example.com",
          password: "password1",
          password_confirmation: "password1"
        }
      }
      expect(response).to have_http_status(:redirect)
    end
  end
end
