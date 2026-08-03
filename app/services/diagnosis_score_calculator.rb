class DiagnosisScoreCalculator
  # @answersに診断の回答データを格納
  def initialize(answers)
    @answers = answers
  end

  # スコア計算
  def calculate
    # スコアを格納するハッシュを作成。デフォルト値は0
    scores = Hash.new(0)
    # 全ての回答データをループ処理
    @answers.each do |answer|
      option = answer.diagnosis_option
      scores[option.weight_category] += option.weight_value
    end

    scores
  end
  
  # カテゴリ判定
  def determine_category(scores)
    # カテゴリの優先順位を定義
    priority_order = ["cost", "medical", "facility"]
    # 全てのスコアの中から最大値を取得
    max_score = scores.values.max
    # 優先順位に従って、最大スコアを持つカテゴリを探す
    priority_order.find { |category| scores[category] == max_score }
  end
end
