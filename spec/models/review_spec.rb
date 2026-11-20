require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "バリデーション" do
    context "cost_ratingが未入力の場合" do
      it "バリデーションエラーになること" do
        review = build(:review, cost_rating: nil)

        expect(review).to be_invalid
      end
    end

    context "cost_ratingが数値以外の場合" do
      it "バリデーションエラーになること" do
        review = build(:review, cost_rating: "高")

        expect(review).to be_invalid
      end
    end

    context "cost_ratingが範囲外の場合" do
      it "バリデーションエラーになること" do
        review = build(:review, cost_rating: "6")

        expect(review).to be_invalid
      end
    end


    context "medical_ratingが未入力の場合" do
      it "バリデーションエラーになること" do
        review = build(:review, medical_rating: nil)

        expect(review).to be_invalid
      end
    end

    context "medical_ratingが数値以外の場合" do
      it "バリデーションエラーになること" do
        review = build(:review, medical_rating: "低")

        expect(review).to be_invalid
      end
    end

    context "medical_ratingが範囲外の場合" do
      it "バリデーションエラーになること" do
        review = build(:review, medical_rating: "6")

        expect(review).to be_invalid
      end
    end

    context "facility_ratingが未入力の場合" do
      it "バリデーションエラーになること" do
        review = build(:review, facility_rating: nil)

        expect(review).to be_invalid
      end
    end

    context "facility_ratingが数値以外の場合" do
      it "バリデーションエラーになること" do
        review = build(:review, facility_rating: "高")

        expect(review).to be_invalid
      end
    end

    context "facility_ratingが範囲外の場合" do
      it "バリデーションエラーになること" do
        review = build(:review, facility_rating: "6")

        expect(review).to be_invalid
      end
    end

    context "全ての値が正しい場合" do
      it "バリデーションを通過すること" do
        review = build(:review)

        expect(review).to be_valid
      end
    end
  end


  describe "アソシエーション" do
    let(:user) { create(:user) }
    let(:facility) { create(:facility) }
    context "ユーザーが削除された場合" do
      it "user_idがnilになること" do
        review = create(:review, user: user, facility: facility)
        user.destroy

        # 最新のDBの状態を反映させるために.reloadでDBから再取得し直す
        expect(review.reload.user_id).to be_nil
      end
    end

    context "施設が削除された場合" do
      it "レビューも削除されること" do
        review = create(:review, user: user, facility: facility)

        # changeマッチャーは、ブロック({ facility.destroy })の実行前と実行後の2回{ Review.count }を評価して差分を比較する
        expect { facility.destroy }.to change { Review.count }.by(-1)
      end
    end
  end
end
