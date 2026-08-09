require 'rails_helper'

RSpec.describe '診断機能', type: :system do
  before(:all) do
    # Seed データを投入
    Rails.application.load_seed
  end

  # Seedデータが投入されていることを前提とする
  before(:each) do
    # Seedデータの存在確認
    expect(Facility.count).to be > 0, "施設データが存在しません"
    expect(DiagnosisQuestion.count).to eq(5), "診断質問が5件必要です"
    expect(DiagnosisResult.count).to eq(3), "診断結果テンプレートが3件必要です"
  end

  describe '診断フロー' do
    it '診断を完了し、3件のおすすめ施設が表示される', js: true do
      # トップ画面にアクセス
      visit root_path
      expect(page).to have_content('診断開始')

      # 診断開始ボタンをクリック
      click_on '診断開始'

      # 診断ページに遷移したことを確認
      expect(page).to have_content('診断質問')

      # 各質問に回答(最初の選択肢を選ぶ)
      questions = DiagnosisQuestion.order(:display_order)
      questions.each do |question|
        first_option = question.diagnosis_options.order(:display_order).first

        # ラジオボタンを選択
        find("input[type='radio'][value='#{first_option.id}']").click
      end

      # 診断結果を表示ボタンをクリック
      within('form') do
        click_button '診断結果を表示'
      end

      # 診断データが作成されていることを確認
      expect(Diagnosis.count).to eq(1)
      diagnosis = Diagnosis.last

      # 診断結果ページに遷移していることを確認
      expect(current_path).to eq(result_diagnosis_path(diagnosis))

      # 診断結果タイトルが表示されていることを確認
      expect(page).to have_content('診断結果')

      # おすすめ施設が表示されていることを確認
      expect(page).to have_content('あなたにおすすめの施設')

      # 施設が3件表示されていることを確認
      expect(page).to have_css('.facility-card', count: 3)
    end
  end

  describe '診断タイプ別の結果表示' do
    it 'コスト重視の選択をすると、コスト重視タイプの結果が表示される', js: true do
      visit root_path
      click_on '診断開始'

      # すべての質問でコスト重視の選択肢を選ぶ
      questions = DiagnosisQuestion.order(:display_order)
      questions.each do |question|
        cost_option = question.diagnosis_options.find_by(weight_category: 'cost')

        if cost_option.present?
          find("input[type='radio'][value='#{cost_option.id}']").click
        else
          # コスト重視の選択肢がない場合は最初の選択肢を選ぶ
          first_option = question.diagnosis_options.order(:display_order).first
          find("input[type='radio'][value='#{first_option.id}']").click
        end
      end

      within('form') do
        click_button '診断結果を表示'
      end

      # コスト重視タイプの結果が表示されることを確認
      expect(page).to have_content('コスト重視タイプ')

      # 施設が3件表示されていることを確認
      expect(page).to have_css('.facility-card', count: 3)
    end
  end

  describe '再診断機能' do
    it '再診断ボタンで診断をやり直せる', js: true do
      visit root_path
      click_on '診断開始'

      # 適当に回答
      questions = DiagnosisQuestion.order(:display_order)
      questions.each do |question|
        first_option = question.diagnosis_options.order(:display_order).first
        choose "question_#{question.id}_option_#{first_option.id}"
      end

      within('form') do
        click_button '診断結果を表示'
      end

      # 再診断ボタンをクリック
      click_on '再診断'

      # 診断ページに戻ることを確認
      expect(page).to have_content('診断質問')

      # 質問が表示されていることを確認
      expect(page).to have_content('駅近で家族が訪問しやすいが料金が高い施設と')
    end
  end
end
