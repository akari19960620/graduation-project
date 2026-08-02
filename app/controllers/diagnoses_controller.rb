class DiagnosesController < ApplicationController
  def new
    @questions = DiagnosisQuestion.includes(:diagnosis_options).order(:display_order)
  end
  # データベースに回答を保存
  def create
    # 保存処理を実行
    if save_responses_to_database
      redirect_to result_diagnoses_path, notice: "回答を保存しました"
    else
      flash[:alert] = "回答の保存に失敗しました"
      redirect_to new_diagnosis_path
    end
  end


  def result
    # 現在のセッションの回答を取得
    @answers = DiagnosisAnswer.includes(:diagnosis_option, :diagnosis_question).where(session_id: current_session_id)
    # 回答がない場合の処理
    if @answers.empty?
      flash[:alert] = "診断を受けてください"
      redirect_to new_diagnosis_path and return
    end
    # スコアを計算
    @scores = calculate_scores(@answers)
    # 最も高いスコアのカテゴリを判定
    @result_category = determine_category(@scores)
    # 該当の診断結果を取得
    @diagnosis_result = DiagnosisResult.find_by!(category: @result_category)
    # おすすめの施設を取得
    @recommended_facilities = recommend_facilities(@result_category)

  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "診断結果が見つかりませんでした"
    redirect_to diagnoses_path
  end


  private

  def calculate_scores(answers)
    # 各カテゴリのスコアを初期化
    scores = Hash.new(0)

    # 各回答からスコアを集計
    answers.each do |answer|
      option = answer.diagnosis_option
      category = option.weight_category
      value = option.weight_value

      scores[category] += value
    end

    scores
  end

  def determine_category(scores)
    # スコアが最も高いカテゴリを取得
    # 同点の場合は cost> medical> facility の優先順位
    priority_order = [ "cost", "medical", "facility" ]
    max_score = scores.values.max

    # 最大スコアを持つカテゴリを優先順位に従って選択
    priority_order.find { |category| scores[category] == max_score }
  end

  # おすすめの施設を取得するメソッドを追加
  def recommend_facilities(category)
    case category
    when "cost"
      Facility.order(cost_score: :desc).limit(3)
    when "medical"
      Facility.order(medical_score: :desc).limit(3)
    when "facility"
      Facility.order(facility_score: :desc).limit(3)
    else
      # デフォルト: 総合評価が高い順（全スコアの平均）
      Facility.all.sort_by do |f|
        (f.cost_score + f.medical_score + f.facility_score) /3.0
      end.reverse.first(3)
    end
  end

  # セッション ID の取得
  def current_session_id
    session.id.private_id
  end

  # 回答をデータベースに保存
  def save_responses_to_database
    DiagnosisAnswer.transaction do
      diagnosis_params.each do |key, value|
        question_id = key.split("_").last.to_i
        option_id = value.to_i

        answer = DiagnosisAnswer.find_or_initialize_by(
          session_id: current_session_id,
          diagnosis_question_id: question_id
        )
        answer.diagnosis_option_id = option_id
        answer.save!
      end
    end
  end

  # 診断の回答データだけを安全に取得するためのストロングパラメータ
  def diagnosis_params
    params.permit(params.keys.select { |key| key.start_with?("question_") })
  end
end
