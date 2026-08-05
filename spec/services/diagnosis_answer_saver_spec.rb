# 回答の保存処理
require 'rails_helper'

RSpec.describe DiagnosisAnswerSaver, type: :service do
  describe '#save' do
    # テストデータの準備
    let!(:question1) { create(:diagnosis_question, display_order: 1) }
    let!(:question2) { create(:diagnosis_question, display_order: 2) }

    let!(:option1_a) { create(:diagnosis_option, diagnosis_question: question1, weight_category: 'cost', weight_value: 20) }
    let!(:option1_b) { create(:diagnosis_option, diagnosis_question: question1, weight_category: 'medical', weight_value: 20) }

    let!(:option2_a) { create(:diagnosis_option, diagnosis_question: question2, weight_category: 'medical', weight_value: 20) }
    let!(:option2_b) { create(:diagnosis_option, diagnosis_question: question2, weight_category: 'facility', weight_value: 20) }

    context '正常系：全ての質問に回答した場合' do
      let(:session_id) { SecureRandom.uuid }

      let(:diagnosis_params) do
        {
          "question_#{question1.id}" => option1_a.id.to_s,
          "question_#{question2.id}" => option2_b.id.to_s
        }
      end

      it '回答が正しく保存される' do
        saver = DiagnosisAnswerSaver.new(session_id, diagnosis_params)

        expect { saver.save }.to change { DiagnosisAnswer.count }.by(2)
      end

      it 'Diagnosisレコードが作成される' do
        saver = DiagnosisAnswerSaver.new(session_id, diagnosis_params)

        expect { saver.save }.to change { Diagnosis.count }.by(1)
      end

      it '保存に成功するとtrueを返す' do
        saver = DiagnosisAnswerSaver.new(session_id, diagnosis_params)

        expect(saver.save).to be true
      end

      it '正しい選択肢が保存される' do
        saver = DiagnosisAnswerSaver.new(session_id, diagnosis_params)
        saver.save

        diagnosis = Diagnosis.last

        answer1 = diagnosis.diagnosis_answers.find_by(diagnosis_question: question1)
        answer2 = diagnosis.diagnosis_answers.find_by(diagnosis_question: question2)

        expect(answer1.diagnosis_option).to eq(option1_a)
        expect(answer2.diagnosis_option).to eq(option2_b)
      end
    end # ← context のend

    context '異常系：不正なデータの場合' do
      let(:session_id) { SecureRandom.uuid }

      let(:invalid_params) do
        {
          "question_#{question1.id}" => nil,
          "question_#{question2.id}" => option2_b.id.to_s
        }
      end

      it '保存に失敗するとfalseを返す' do
        saver = DiagnosisAnswerSaver.new(session_id, invalid_params)

        expect(saver.save).to be false
      end

      it 'DiagnosisAnswerレコードが作成されない' do
        saver = DiagnosisAnswerSaver.new(session_id, invalid_params)

        expect { saver.save }.not_to change { DiagnosisAnswer.count }
      end
    end # ← context のend

    context '過去の診断結果の削除' do
      let(:session_id) { SecureRandom.uuid }

      let!(:old_diagnosis) { create(:diagnosis, session_id: session_id) }
      let!(:old_answer) { create(:diagnosis_answer, diagnosis: old_diagnosis, diagnosis_question: question1, diagnosis_option: option1_a) }

      let(:new_params) do
        {
          "question_#{question1.id}" => option1_b.id.to_s,
          "question_#{question2.id}" => option2_a.id.to_s
        }
      end

      it '過去の診断が削除される' do
        saver = DiagnosisAnswerSaver.new(session_id, new_params)

        expect { saver.save }.to change { Diagnosis.where(session_id: session_id).count }.by(0)
        expect(Diagnosis.exists?(old_diagnosis.id)).to be false
      end

      it '過去の回答が削除される' do
        saver = DiagnosisAnswerSaver.new(session_id, new_params)

        expect { saver.save }.to change { DiagnosisAnswer.count }.by(1)
        expect(DiagnosisAnswer.exists?(old_answer.id)).to be false
      end
    end # ← context のend

    context '同じ診断で回答を更新する場合' do
      let(:session_id) { SecureRandom.uuid }

      let!(:diagnosis) { create(:diagnosis, session_id: session_id) }
      let!(:answer1) { create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question1, diagnosis_option: option1_a) }

      let(:update_params) do
        {
          "question_#{question1.id}" => option1_b.id.to_s,
          "question_#{question2.id}" => option2_a.id.to_s
        }
      end

      it '既存の回答が更新される' do
        saver = DiagnosisAnswerSaver.new(session_id, update_params)
        saver.save

        new_diagnosis = Diagnosis.find_by(session_id: session_id)

        answer1 = new_diagnosis.diagnosis_answers.find_by(diagnosis_question: question1)
        answer2 = new_diagnosis.diagnosis_answers.find_by(diagnosis_question: question2)

        expect(answer1.diagnosis_option).to eq(option1_b)
        expect(answer2.diagnosis_option).to eq(option2_a)
      end
    end
  end
end
