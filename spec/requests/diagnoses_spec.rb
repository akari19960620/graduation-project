require 'rails_helper'

RSpec.describe "DiagnosisQuestions", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get diagnoses_path, headers: { 'HOST' => 'localhost' }

      expect(response).to have_http_status(:success)
    end
  end
end
