class DiagnosisResult < ApplicationRecord
  has_many :facility_matches, dependent: :destroy
  has_many :facilities, through: :facility_matches

  # スコアの範囲で結果を検索するメソッド
  def self.find_by_score(score)
    where("min_score <= ? AND max_score >= ?", score, score).first
  end
end
