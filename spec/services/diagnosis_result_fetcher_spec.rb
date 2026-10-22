# 計算結果とおすすめ施設の取得
require 'rails_helper'

RSpec.describe DiagnosisResultFetcher do
  describe '#fetch' do
    context '正常系' do
      # 既存のデータをすべて削除
      before(:each) do
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

      # facility_typeごとに上位2件に絞られることを検証するためのデータ
      # 同じfacility_typeを3件用意し、最もcost_scoreが低い1件が除外されることを確認する
      let!(:facility1) { create(:facility, :cost_focused, name: '施設A', facility_type: '介護付き有料老人ホーム', cost_score: 5) }
      let!(:facility2) { create(:facility, :cost_focused, name: '施設B', facility_type: '介護付き有料老人ホーム', cost_score: 4) }
      let!(:facility3) { create(:facility, name: '施設C', facility_type: '介護付き有料老人ホーム', cost_score: 3) }
      let!(:facility4) { create(:facility, name: '施設D', facility_type: '特別養護老人ホーム', cost_score: 2) }


      it '診断結果データが正しく取得できること' do
        fetcher = described_class.new(diagnosis.id)
        result = fetcher.fetch

        # 検証
        expect(result[:category]).to eq('cost')
        expect(result[:result].id).to eq(diagnosis_result.id)
        # 同facility_type内で上位2件(facility1, facility2)のみ残り、
        # 3位のfacility3は除外され、別facility_typeのfacility4は残ることを確認
        expect(result[:recommended_facilities]).to match_array([ facility1, facility2, facility4 ])
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
