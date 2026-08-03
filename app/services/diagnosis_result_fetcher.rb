class DiagnosisResultFetcher
  # セッションIDをインスタンス変数に格納
  def initialize(session_id)
    @session_id = session_id
  end
  # 診断結果の取得
  def fetch
    answers = fetch_answers
    result_data = calculate_scores_and_category(answers)  # ① スコアとカテゴリーを同時取得
    scores = result_data[:scores] # スコアを取り出す
    category = result_data[:category] # カテゴリーを取り出す
    result = fetch_result(category)
    recommended_facilities = fetch_recommended_facilities(category)

    build_result_data(answers, scores, category, result, recommended_facilities)
  end

  private

  # 診断回答の取得と検証
  def fetch_answers
    # まず Diagnosis を session_id で取得
    diagnosis = Diagnosis.find_by(session_id: @session_id)
    # Diagnosis が存在しない場合は例外を投げる
    raise DiagnosisResultNotFoundError, "診断が見つかりません" if diagnosis.nil?

    # Diagnosis に紐づくdiagnosis_answersを取得
    answers = diagnosis.diagnosis_answers.includes(:diagnosis_option)
    # 回答が存在しない場合は例外を投げる
    raise DiagnosisResultNotFoundError, "診断回答が見つかりません" if answers.empty?
    answers
  end

  # スコア計算とカテゴリー判定（1回の呼び出しで両方取得）
  def calculate_scores_and_category(answers)
    calculator = DiagnosisScoreCalculator.new(answers)
    calculator.calculate  # ← { scores: ..., category: ... } が返ってくる
  end

  # 診断結果の取得
  def fetch_result(category)
    DiagnosisResult.find_by!(category: category)
  end

  # おすすめ施設の取得
  def fetch_recommended_facilities(category)
    DiagnosisResult.find_by(category: category)&.facilities&.limit(3) || []
  end

  # 結果データの構築
  def build_result_data(answers, scores, category, result, recommended_facilities)
    {
      answers: answers,
      scores: scores,
      category: category,
      result: result,
      recommended_facilities: recommended_facilities
    }
  end
end
