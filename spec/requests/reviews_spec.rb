require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "GET /facilities/:facility_id/reviews/new" do
    let(:user) { create(:user) }
    let(:facility) { create(:facility) }

    context "ログインしている場合" do
      before { sign_in_as(user) }
      it "口コミ投稿ページが表示されること" do
        get new_facility_review_path(facility)

        expect(response).to have_http_status(:success)
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされること" do
        get new_facility_review_path(facility)

        expect(response).to redirect_to(new_login_path)
      end
    end
  end

  describe "POST /facilities/:facility_id/reviews" do
    let(:user) { create(:user) }
    let(:facility) { create(:facility) }
    let(:valid_params) do
      { review: { cost_rating: 3, medical_rating: 3, facility_rating: 3 } }
    end
    let(:invalid_params) do
      { review: { cost_rating: nil, medical_rating: nil, facility_rating: nil } }
    end

    context "ログインしている場合" do
      before { sign_in_as(user) }

      context "必須項目が入力されている場合" do
        it "レビューが作成されること" do
          expect {
            post facility_reviews_path(facility), params: valid_params
          }.to change(Review, :count).by(1)
        end
      end

      context "必須項目未入力の場合" do
        it "レビューが作成されないこと" do
          expect {
            post facility_reviews_path(facility), params: invalid_params
          }.to change(Review, :count).by(0)
        end
      end
    end

    context "未ログインの場合" do
      it "レビューが作成されないこと" do
        expect {
          post facility_reviews_path(facility), params: valid_params
        }.to change(Review, :count).by(0)
      end
    end
  end
end
