require 'rails_helper'

RSpec.describe "Favorites", type: :system do
  let(:user) { create(:user) }
  let(:facility) { create(:facility) }

  describe 'お気に入り一覧ページ' do
    context 'ログイン済みの場合' do
      before { login_as(user) }

      it '一覧ページが表示される' do
        visit favorites_path

        expect(page).to have_content "お気に入り一覧"
      end

      context 'お気に入り登録済みの施設がある場合' do
        before { create(:favorite, user: user, facility: facility) }

        it 'お気に入り登録した施設が表示される' do
          visit favorites_path

          expect(page).to have_content facility.name
        end

        it '一覧ページからお気に入りを解除できる' do
          visit favorites_path
          click_button "♥"

          expect(page).not_to have_content facility.name
        end
      end

      context 'お気に入りが０件の場合' do
        it 'お気に入りが０件である旨のメッセージが表示される' do
          visit favorites_path

          expect(page).to have_content "お気に入りに登録されている施設はありません。"
        end
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトされる' do
        visit favorites_path

        expect(current_path).to eq new_login_path
      end
    end
  end
end
