require 'rails_helper'

RSpec.describe "DiagnosisQuestions", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get diagnosis_questions_path, headers: { 'HOST' => 'localhost' }

      # デバッグ用の出力
      puts "=" * 50
      puts "Response status: #{response.status}"
      puts "Response body:"
      puts response.body
      puts "=" * 50

      expect(response).to have_http_status(:success)
    end
  end
end
