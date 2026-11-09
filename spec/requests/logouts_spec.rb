require "rails_helper"

RSpec.describe "Logouts", type: :request do
  let(:user) { create(:user, password: "password1", password_confirmation: "password1") }

  before do
    post login_path, params: { email: user.email, password: "password1" }
  end

  describe "DELETE /logout" do
    it "ログアウトに成功し、トップページにリダイレクトされる" do
      delete logout_path
      expect(response).to redirect_to(root_path)
      expect(response).to have_http_status(:see_other)
    end
  end
end
