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

      # ページの読み込みを待機
      expect(page).to have_content('診断開始', wait: 10)

      # リンクをクリック
      click_link '診断開始'

      # 診断フォームの要素が表示されるまで待機
      expect(page).to have_css('.question', wait: 10)

      # デバッグ: 質問の数を確認
      question_count = all('.question').count
      puts "質問の数: #{question_count}"

      all('.question').each do |question|
        # 各質問内の最初のラジオボタンを選択
        question.first('.option input[type="radio"]').click
      end

       # デバッグ: 回答した数を確認
      answered_count = all('.option input[type="radio"]:checked').count
      puts "回答した数: #{answered_count}"

      # デバッグ: ボタンの存在確認
      if page.has_button?('診断結果を表示')
        puts "「診断結果を表示」ボタンが見つかりました"
      else
        puts "「診断結果を表示」ボタンが見つかりません"
        puts "ページの内容: #{page.text}"
      end

      # デバッグ: フォーム送信前のパス
      puts "フォーム送信前のパス: #{current_path}"


      # 次へボタンをクリック
      click_button '診断結果を表示'
      
      # フォーム送信後、少し待機
      sleep 2

      # デバッグ: フォーム送信後のパス
      puts "フォーム送信後のパス: #{current_path}"

      # 診断結果ページに遷移することを確認
      expect(page).to have_current_path(/\/diagnoses\/\d+\/result/)

      # 診断結果のタイトルが表示されることを確認
      expect(page).to have_content(/重視タイプ/)

      # おすすめ施設が3件表示されることを確認
      expect(page).to have_css('.facility-card', count: 3)
    end
  end
end
