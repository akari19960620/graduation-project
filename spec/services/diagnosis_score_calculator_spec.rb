# スコア計算とタイプ判定
require 'rails_helper'
require Rails.root.join('app/services/diagnosis_score_calculator')

RSpec.describe DiagnosisScoreCalculator do
  describe 'スコア計算とカテゴリー判定' do
    let(:diagnosis) { create(:diagnosis) }

    context '複数の回答から各カテゴリーのスコアが正しく計算される' do
      it 'すべてのカテゴリーのスコアが正しく合算され、最高スコアのカテゴリーが判定される' do
        # 質問1: コスト vs 医療体制
        question1 = create(:diagnosis_question)
        option1_a = create(:diagnosis_option, diagnosis_question: question1, weight_category: 'cost', weight_value: 20)      # コスト重視
        option1_b = create(:diagnosis_option, diagnosis_question: question1, weight_category: 'medical', weight_value: 20)  # 医療重視

        # 質問2: 医療体制 vs 施設充実度
        question2 = create(:diagnosis_question)
        option2_a = create(:diagnosis_option, diagnosis_question: question2, weight_category: 'medical', weight_value: 20)   # 医療重視
        option2_b = create(:diagnosis_option, diagnosis_question: question2, weight_category: 'facility', weight_value: 20) # 施設重視

        # 質問3: コスト vs 施設充実度
        question3 = create(:diagnosis_question)
        option3_a = create(:diagnosis_option, diagnosis_question: question3, weight_category: 'cost', weight_value: 20)      # コスト重視
        option3_b = create(:diagnosis_option, diagnosis_question: question3, weight_category: 'facility', weight_value: 20) # 施設重視

        # 回答を作成（ユーザーがどちらを選んだか）
        answer1 = create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question1, diagnosis_option: option1_b)  # 医療重視を選択
        answer2 = create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question2, diagnosis_option: option2_a)  # 医療重視を選択
        answer3 = create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question3, diagnosis_option: option3_a)  # コスト重視を選択

        answers = [ answer1, answer2, answer3 ]

        # 計算実行
        calculator = DiagnosisScoreCalculator.new(answers)
        result = calculator.calculate

        # スコア検証
        expect(result[:scores]['cost']).to eq(20)
        expect(result[:scores]['medical']).to eq(40)
        expect(result[:scores]['facility']).to eq(0)

        # カテゴリー判定検証
        expect(result[:category]).to eq('medical')
      end
    end

    context '複数のカテゴリーで同じスコアの場合' do
      it '優先度に従って正しくカテゴリーが判定される' do
        # 質問1: コスト vs 医療体制
        question1 = create(:diagnosis_question)
        option1_a = create(:diagnosis_option, diagnosis_question: question1, weight_category: 'cost', weight_value: 20)      # コスト重視
        option1_b = create(:diagnosis_option, diagnosis_question: question1, weight_category: 'medical', weight_value: 20)  # 医療重視

        # 質問2: 医療体制 vs 施設充実度
        question2 = create(:diagnosis_question)
        option2_a = create(:diagnosis_option, diagnosis_question: question2, weight_category: 'medical', weight_value: 20)   # 医療重視
        option2_b = create(:diagnosis_option, diagnosis_question: question2, weight_category: 'facility', weight_value: 20) # 施設重視

        # 質問3: コスト vs 施設充実度
        question3 = create(:diagnosis_question)
        option3_a = create(:diagnosis_option, diagnosis_question: question3, weight_category: 'cost', weight_value: 20)      # コスト重視
        option3_b = create(:diagnosis_option, diagnosis_question: question3, weight_category: 'facility', weight_value: 20) # 施設重視

        # 質問1: コスト vs 医療体制
        question4 = create(:diagnosis_question)
        option1_a = create(:diagnosis_option, diagnosis_question: question4, weight_category: 'cost', weight_value: 20)      # コスト重視
        option1_b = create(:diagnosis_option, diagnosis_question: question4, weight_category: 'medical', weight_value: 20)  # 医療重視

        # 回答を作成（ユーザーがどちらを選んだか）
        answer1 = create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question1, diagnosis_option: option1_b)  # 医療重視を選択
        answer2 = create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question2, diagnosis_option: option2_a)  # 医療重視を選択
        answer3 = create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question3, diagnosis_option: option3_a)  # コスト重視を選択
        answer4 = create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question4, diagnosis_option: option3_a)  # コスト重視を選択

        answers = [ answer1, answer2, answer3, answer4 ]

        calculator = DiagnosisScoreCalculator.new(answers)
        result = calculator.calculate

        expect(result[:scores]['cost']).to eq(40)
        expect(result[:scores]['medical']).to eq(40)
        expect(result[:scores]['facility']).to eq(0)

        # 優先順位: cost > medical > facility
        expect(result[:category]).to eq('cost')
      end
    end
  end
end
