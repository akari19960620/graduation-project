class Facility < ApplicationRecord
  # カテゴリ名とスコアカラム名の対応表
  SCORE_COLUMNS = {
    "cost" => "cost_score",
    "medical" => "medical_score",
    "facility" => "facility_score"
  }.freeze

  # カテゴリに応じたスコアで、施設タイプごとに上位2件を取得
  def self.recommend_by_category(category)
    score_column = SCORE_COLUMNS[category]
    return [] if score_column.nil? # 想定外のカテゴリが来た場合の安全対策

    order(score_column => :desc) # 先にスコアで全体を並び替える
      .group_by(&:facility_type) # facility_typeでグループ化（Rubyのgroup_byは元の順序を保持する）
      .flat_map { |_type, facilities| facilities.first(2) } # 各グループの上位2件を取り出す
  end
end
