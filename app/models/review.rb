class Review < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :facility

  validates :cost_rating, :facility_rating, :medical_rating, presence: true
  # 5段階評価(1〜5の整数のみを許可)のバリデーション
  validates :cost_rating, :facility_rating, :medical_rating,
            inclusion: { in: 1..5, message: "は1から5の範囲で選択してください" }
end
