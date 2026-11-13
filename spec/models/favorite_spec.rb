require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:facility) { create(:facility) }

  describe "登録に関するバリデーション" do
    context "同じUserとFacilityの組み合わせで登録しようとした場合" do
      it "登録できないこと" do
        create(:favorite, user: user, facility: facility)
        duplicate_favorite = build(:favorite, user: user, facility: facility)

        expect(duplicate_favorite).not_to be_valid
      end
    end

    context "異なるFacilityであれば同じUserで登録できる場合" do
      it "登録できること" do
        create(:favorite, user: user, facility: facility)
        other_facility = create(:facility)
        other_favorite = build(:favorite, user: user, facility: other_facility)

        expect(other_favorite).to be_valid
      end
    end
  end

  describe "関連レコード削除時の挙動" do
    # beforeで各テストが実行される前に、UserとFacilityに紐づくFavoriteを作成
    before { create(:favorite, user: user, facility: facility) }

    it "Userが削除されると、紐づくお気に入りも削除されること" do
      expect { user.destroy }.to change(Favorite, :count).by(-1)
    end

    it "Facilityが削除されると、紐づくお気に入りも削除されること" do
      expect { facility.destroy }.to change(Favorite, :count).by(-1)
    end
  end
end
