require 'rails_helper'

RSpec.describe "Logins", type: :request do
  let(:user) { create(:user, password: "password1", password_confirmation: "password1") }

  describe "GET /new" do
    it "ログインページが正常に表示される" do
      get new_login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "メールアドレスとパスワードが正しい場合" do
      it "ログインに成功し、トップページにリダイレクトされる" do
        post login_path, params: { email: user.email, password: "password1" }
        expect(response).to redirect_to(root_path)
      end
    end

    context "メールアドレスとパスワードが正しくない場合" do
      it "ログインに失敗し、ステータス422でログインページが再表示される" do
        post login_path, params: { email: user.email, password: "wrongpassword" }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
