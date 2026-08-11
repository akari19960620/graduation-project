require 'rails_helper'

RSpec.describe '診断機能', type: :system do
  # テストデータをセットアップ
  before do
    # 診断質問セットを作成
    create_complete_diagnosis_questions

    # 診断結果セットを作成(施設付き)
    create_complete_diagnosis_results_with_facilities
  end

  describe '診断フロー' do
    it '診断を完了し、3件のおすすめ施設が表示される', js: true do
      # トップ画面にアクセス
      visit root_path
      # 診断開始ボタンをクリック
      click_link '診断開始'

      expect(page).to have_current_path(new_diagnosis_path)

      all('.question').each do |question|
        # 各質問内の最初のラジオボタンを選択
        question.first('.option input[type="radio"]').click
      end
      # 次へボタンをクリック
      click_button '診断結果を表示'

      # 診断結果ページに遷移することを確認
      expect(page).to have_current_path(/\/diagnoses\/\d+\/result/)

      # 診断結果のタイトルが表示されることを確認
      expect(page).to have_content(/重視タイプ/)

      # おすすめ施設が3件表示されることを確認
      expect(page).to have_css('.facility-card', count: 3)
    end
  end
end
