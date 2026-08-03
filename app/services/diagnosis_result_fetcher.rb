class DiagnosisResultFetcher
  # セッションIDをインスタンス変数に格納
  def initialize(session_id)
    @session_id = session_id
  end
  # 診断結果の取得
  def fetch
    # ユーザーの回答データを読み込む
    answers = load_answers
    return nil if answers.empty?

    # DiagnosisScoreCalculatorインスタンスを作成し、回答データを渡す
    calculator = DiagnosisScoreCalculator.new(answers)
    scores = calculator.calculate # スコア計算
    category = calculator.determine_category(scores) # もっともスコアが高いカテゴリを判定

    {
      answers: answers, # 回答データ
      scores: scores, # スコア
      category: category, # 判定されたカテゴリ
      result: DiagnosisResult.find_by!(category: category), # 診断結果
      recommended_facilities: fetch_recommended_facilities(category) # おすすめ施設
    }
  end
  
  private

  # 回答データの読み込み（関連データを１度に取得）、（指定されたセッションIDのみ取得）
  def load_answers
    DiagnosisAnswer.includes(:diagnosis_option, :diagnosis_question).where(session_id: @session_id)
  end

  # おすすめの施設の取得
  def fetch_recommended_facilities(category) # カテゴリに対応する診断結果を取得
    DiagnosisResult.find_by(category: category)&.facilities&.limit(3) || [] # &.（resultがnilでなければfacilitiesを呼び出す）|| []でデフォルト値を設定（左側がnilの場合、空の配列を返す）
  end
end