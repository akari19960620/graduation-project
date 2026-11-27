require 'rails_helper'

RSpec.describe '口コミ一覧表示', type: :system do
  let(:facility) { create(:facility) }
  context '口コミが存在する場合' do
    before do
      create(:review, facility: facility, cost_rating: 3, medical_rating: 2, facility_rating: 5, comment: '最新の設備がそろってました')
      create(:review, facility: facility, cost_rating: 5, medical_rating: 4, facility_rating: 5, comment: '全体的に素敵な施設でした')
    end

    it '個別の口コミ内容が表示される' do
      visit facility_path(facility)

      expect(page).to have_content('最新の設備がそろってました')
      expect(page).to have_content('全体的に素敵な施設でした')
    end

    it '平均評価が表示される' do
      visit facility_path(facility)

      expect(page).to have_content('評価サマリー')
      expect(page).to have_content('費用')
      expect(page).to have_content('4.0 / 5')
      expect(page).to have_content('医療')
      expect(page).to have_content('3.0 / 5')
      expect(page).to have_content('環境')
      expect(page).to have_content('5.0 / 5')
    end
  end

  context '口コミが0件の場合' do
    it '「口コミがありません」と表示される' do
      visit facility_path(facility)

      expect(page).to have_content('口コミがありません')
    end
  end
end
