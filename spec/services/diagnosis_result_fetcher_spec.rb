# 計算結果とおすすめ施設の取得
require 'rails_helper'

RSpec.describe DiagnosisResultFetcher do
  describe '#fetch' do
    context '正常系' do
      # 既存のデータをすべて削除
      before do
        Facility.destroy_all
        Diagnosis.destroy_all
        DiagnosisAnswer.destroy_all
        DiagnosisResult.destroy_all
        FacilityMatch.destroy_all
        DiagnosisQuestion.destroy_all
        DiagnosisOption.destroy_all
      end

      let!(:diagnosis) { create(:diagnosis) }
      let!(:fetcher) { described_class.new(diagnosis.id) }

      let!(:diagnosis_result) { create(:diagnosis_result, category: 'cost') }

      let!(:question) { create(:diagnosis_question, display_order: 1) }
      let!(:option) { create(:diagnosis_option, diagnosis_question: question, weight_category: 'cost', weight_value: 20) }
      let!(:answer) { create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question, diagnosis_option: option) }

      let!(:facility1) { create(:facility, name: 'テスト施設1') }
      let!(:facility2) { create(:facility, name: 'テスト施設2') }
      let!(:facility3) { create(:facility, name: 'テスト施設3') }

      before do
        create(:facility_match, diagnosis_result: diagnosis_result, facility: facility1)
        create(:facility_match, diagnosis_result: diagnosis_result, facility: facility2)
        create(:facility_match, diagnosis_result: diagnosis_result, facility: facility3)
      end

      it '診断結果データが正しく取得できること' do
        result = fetcher.fetch

        # IDで比較,名前で比較
        expect(result[:recommended_facilities].pluck(:id)).to match_array([ facility1.id, facility2.id, facility3.id ])
        expect(result[:recommended_facilities].pluck(:name)).to match_array([ 'テスト施設1', 'テスト施設2', 'テスト施設3' ])
      end
    end

    context '異常系' do
      it '診断が見つからない場合に例外が発生すること' do
        fetcher = described_class.new(999)
        expect { fetcher.fetch }.to raise_error(DiagnosisResultNotFoundError)
      end
    end
  end
end
