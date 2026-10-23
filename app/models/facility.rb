class Facility < ApplicationRecord
  # カテゴリ名とスコアカラム名の対応表
  SCORE_COLUMNS = {
    "cost" => "cost_score",
    "medical" => "medical_score",
    "facility" => "facility_score"
  }.freeze

   # 施設タイプごとの説明文
  FACILITY_DESCRIPTIONS = {
    "特別養護老人ホーム" => "社会福祉法人や自治体が運営する公的な介護保険施設です。費用が比較的安く、終身利用（看取り）に対応しているケースが多いですが、入居待ちが発生しやすい傾向にあります。",
    "高齢者向け住宅" => "「自由な暮らしやプライベートを大切にしたい、お元気な方向けの住まい」です。「賃貸タイプ（サ高住など）」と「分譲タイプ（シニア向け分譲マンションなど）」の2つの選択肢があります。",
    "有料老人ホーム" => "民間企業などが運営する施設で、サービス内容や費用の幅が広いのが特徴です。「介護付」「住宅型」「健康型」の3種類があります。",
    "グループホーム" => "認知症の高齢者が、5〜9人の小規模なユニット（単位）で専門スタッフのサポートを受けながら共同生活を送る地域密着型の施設です。",
    "ケアハウス" => "自宅での生活に不安があるものの、比較的低価格で利用したい方向けの公的・半公的な施設です。「一般型（自立向け）」と「特定施設（介護が必要な方向け）」があります。"
  }.freeze

  # カテゴリに応じたスコアで、施設タイプごとに上位2件を取得
  def self.recommend_by_category(category)
    score_column = SCORE_COLUMNS[category]
    return [] if score_column.nil? # 想定外のカテゴリが来た場合の安全対策

    order(score_column => :desc) # 先にスコアで全体を並び替える
      .group_by(&:facility_type) # facility_typeでグループ化（Rubyのgroup_byは元の順序を保持する）
      .flat_map { |_type, facilities| facilities.first(2) } # 各グループの上位2件を取り出す
  end

  # facility_type に対応する説明文を返す
  def facility_description
    FACILITY_DESCRIPTIONS[facility_type]
  end
end
