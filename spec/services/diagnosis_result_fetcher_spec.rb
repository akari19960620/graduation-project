# 診断結果の取得とおすすめ施設の取得
require 'rails_helper'

RSpec.describe DiagnosisResultFetcher do
  let(:session_id) { SecureRandom.uuid }
  let(:fetcher) { described_class.new(session_id) }

  describe '#fetch' do
    context '正常系' do
      let!(:diagnosis) { create(:diagnosis, session_id: session_id) }
      let!(:diagnosis_result) { create(:diagnosis_result, category: 'cost') }
      
      let!(:question) { create(:diagnosis_question, display_order: 1) }
      let!(:option) { create(:diagnosis_option, diagnosis_question: question, weight_category: 'cost', weight_value: 3) }
      let!(:answer) { create(:diagnosis_answer, diagnosis: diagnosis, diagnosis_question: question, diagnosis_option: option) }
      
      let!(:facility1) { create(:facility) }
      let!(:facility2) { create(:facility) }
      let!(:facility3) { create(:facility) }
      
      before do
        create(:facility_match, diagnosis_result: diagnosis_result, facility: facility1)
        create(:facility_match, diagnosis_result: diagnosis_result, facility: facility2)
        create(:facility_match, diagnosis_result: diagnosis_result, facility: facility3)
      end

      it '診断結果データが正しく取得できること' do
        result = fetcher.fetch
        
        expect(result[:category]).to eq('cost')
        expect(result[:result]).to eq(diagnosis_result)
        expect(result[:recommended_facilities].count).to eq(3)
      end
    end

    context '異常系' do
      it '診断が見つからない場合に例外が発生すること' do
        expect { fetcher.fetch }.to raise_error(DiagnosisResultNotFoundError)
      end
    end
  end
end
