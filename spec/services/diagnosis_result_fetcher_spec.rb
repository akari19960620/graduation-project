# 計算結果とおすすめ施設の取得
require 'rails_helper'

RSpec.describe DiagnosisResultFetcher do
  describe '#fetch' do
    context '正常系' do
      # 既存のデータをすべて削除
      before(:each) do
        FacilityMatch.destroy_all
        DiagnosisAnswer.destroy_all
        DiagnosisOption.destroy_all
        DiagnosisQuestion.destroy_all
        DiagnosisResult.destroy_all
        Facility.destroy_all
        Diagnosis.destroy_all
      end

      let!(:diagnosis) { create(:diagnosis) }
      # ★ 修正: 診断結果を先に作成
      let!(:diagnosis_result) { create(:diagnosis_result, category: 'cost') }

      # ★ 修正: 複数の質問を作成し、すべて 'cost' カテゴリーの選択肢を選ぶ
      # 質問1: cost カテゴリー
      let!(:question1) { create(:diagnosis_question, display_order: 1) }
      let!(:option1) { create(:diagnosis_option, diagnosis_question: question1, weight_category: 'cost', weight_value: 20) }
      let!(:answer1) { create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question1, diagnosis_option: option1) }

      # 質問2: cost カテゴリー
      let!(:question2) { create(:diagnosis_question, display_order: 2) }
      let!(:option2) { create(:diagnosis_option, diagnosis_question: question2, weight_category: 'cost', weight_value: 20) }
      let!(:answer2) { create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question2, diagnosis_option: option2) }

      # 質問3: cost カテゴリー
      let!(:question3) { create(:diagnosis_question, display_order: 3) }
      let!(:option3) { create(:diagnosis_option, diagnosis_question: question3, weight_category: 'cost', weight_value: 20) }
      let!(:answer3) { create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question3, diagnosis_option: option3) }


      let!(:facility1) { create(:facility, name: 'テスト施設1') }
      let!(:facility2) { create(:facility, name: 'テスト施設2') }
      let!(:facility3) { create(:facility, name: 'テスト施設3') }

      before do
        create(:facility_match, diagnosis_result: diagnosis_result, facility: facility1)
        create(:facility_match, diagnosis_result: diagnosis_result, facility: facility2)
        create(:facility_match, diagnosis_result: diagnosis_result, facility: facility3)
      end

      it '診断結果データが正しく取得できること' do
        fetcher = described_class.new(diagnosis.id)
        result = fetcher.fetch

        # 検証
        expect(result[:category]).to eq('cost')
        expect(result[:result].id).to eq(diagnosis_result.id)
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
