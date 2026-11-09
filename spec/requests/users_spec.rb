require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "ユーザー登録ページが正常に表示される" do
      get new_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "正常な入力情報の場合" do
      it "ユーザーが正常に登録され、トップページにリダイレクトされる" do
        expect {
          post users_path, params: {
            user: {
              name: "テストユーザー",
              email: "testtest@example.com",
              password: "password1",
              password_confirmation: "password1"
            }
          }
        }.to change(User, :count).by(1)  # Userのレコードが1件増えたことを検証
        expect(response).to redirect_to(root_path)
      end
    end

    context "不足した入力情報の場合" do
      it "ユーザ登録に失敗し、ステータス422でユーザー登録ページが再表示される" do
        expect {
          post users_path, params: {
            user: {
              name: "テストユーザー",
              email: "",
            password: "password1",
            password_confirmation: "password1"
            }
          }
        }.not_to change(User, :count)  # ユーザーが作成されていないことを検証
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
