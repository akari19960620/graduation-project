class DiagnosisResult < ApplicationRecord
  ALLOWED_CATEGORIES = %w[cost medical facility].freeze
  
  # スコアの範囲で結果を検索するメソッド
  def self.find_by_score(score)
    where("min_score <= ? AND max_score >= ?", score, score).first
  end
  # 施設タイプごとに、指定したカテゴリのスコアが高い施設を指定件数だけ取得するメソッド
  def top_facilities(limit_count_per_type)
    return [] unless ALLOWED_CATEGORIES.include?(category)

    column_name = "#{category}_score"

    Facility.distinct.pluck(:facility_type).flat_map do |type|
      Facility.where(facility_type: type)
              .order(column_name => :desc)
              .limit(limit_count_per_type)
    end
  end
end
