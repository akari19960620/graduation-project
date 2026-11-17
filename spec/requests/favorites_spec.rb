require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:facility) { create(:facility) }

  describe "POST /create" do
    context "ログイン済みユーザーの場合" do
      before { sign_in_as(user) }  # create(:user)が実行され、sign_in_asメソッドでログイン状態を作り出す

      it "お気に入り登録できる" do
        puts "itブロック内のobject_id: #{user.object_id}"  # 追加
        post facility_favorites_path(facility)

        expect(response).to redirect_to(facility_path(facility))
        expect(Favorite.count).to eq(1)
      end
    end

    context "未ログインユーザーの場合" do
      it "お気に入り登録できない" do
        # facilityをネストしているため、facility_favorites_path(facility)
        post facility_favorites_path(facility)

        expect(response).to redirect_to(new_login_path)
        expect(Favorite.count).to eq(0)
      end
    end
  end

  describe "DELETE /destroy" do
    context "ログイン済みユーザーの場合" do
      let!(:favorite) { create(:favorite, user: user, facility: facility) }
      before { sign_in_as(user) }

      it "お気に入り登録を解除できる" do
        # ルーティングでshallow: trueを指定しているため、destroyは単純化される
        delete favorite_path(favorite)

        expect(Favorite.count).to eq(0)
      end

      it "お気に入り一覧ページから解除した場合、お気に入り一覧ページにリダイレクトされる" do
        # headers: { "HTTP_REFERER" => favorites_url } で直前に一覧ページを見ていたという情報をリクエストに含める
        delete favorite_path(favorite), headers: { "HTTP_REFERER" => favorites_url }

        expect(response).to redirect_to(favorites_path)
      end

      it "施設詳細ページから解除した場合、施設詳細ページにリダイレクトされる" do
        delete favorite_path(favorite), headers: { "HTTP_REFERER" => facility_url(facility) }

        expect(response).to redirect_to(facility_path(facility))
      end
    end

    context "未ログインユーザーの場合" do
      let!(:favorite) { create(:favorite, user: user, facility: facility) }

      it "お気に入り登録を解除できない" do
        delete favorite_path(favorite)

        expect(response).to redirect_to(new_login_path)
        expect(Favorite.count).to eq(1)
      end
    end
  end
end
