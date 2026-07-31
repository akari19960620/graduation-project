class DiagnosisResult < ApplicationRecord
  # スコアの範囲で結果を検索するメソッド
  def self.find_by_score(score)
    where("min_score <= ? AND max_score >= ?", score, score).first
  end
end
