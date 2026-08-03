class DiagnosisScoreCalculator
  # @answersに診断の回答データを格納
  def initialize(answers)
    @answers = answers
  end

  # スコア計算とカテゴリー判定を同時に行う
  def calculate
    scores = calculate_scores          # ① スコアを計算
    category = determine_category(scores)  # ② カテゴリーを判定

    { scores: scores, category: category }  # ③ ハッシュで両方を返す
  end

  private

  # スコア計算ロジック
  def calculate_scores
    scores = Hash.new(0)
    @answers.each do |answer|
      option = answer.diagnosis_option
      scores[option.weight_category] += option.weight_value
    end
    scores
  end

  # カテゴリ判定
  def determine_category(scores)
    # カテゴリの優先順位を定義
    priority_order = [ "cost", "medical", "facility" ]
    # 全てのスコアの中から最大値を取得
    max_score = scores.values.max
    # 優先順位に従って、最大スコアを持つカテゴリを探す
    priority_order.find { |category| scores[category] == max_score }
  end
end
