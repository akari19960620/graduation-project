require 'rails_helper'

RSpec.describe "Diagnoses", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get new_diagnosis_path, headers: { 'HOST' => 'localhost' }

      expect(response).to have_http_status(:success)
    end
  end
end
