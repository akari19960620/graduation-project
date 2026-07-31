class DiagnosesController < ApplicationController
  def new
    @questions = DiagnosisQuestion.includes(:diagnosis_options).order(:display_order)
  end
  # データベースに回答を保存
  def create
    # 保存処理を実行
    if save_responses_to_database
      # 一旦、診断一覧にリダイレクト
      redirect_to diagnoses_path, notice: "回答を保存しました"
    else
      flash[:alert] = "回答の保存に失敗しました"
      redirect_to diagnoses_path
    end
  end


  # def result
  # スコアを計算
  # @total_score = calculate_total_score
  # 診断結果を取得
  # @diagnosis_result = DiagnosisResult.find_by_score(@total_score)
  # ビューで使用するために回答データを整形
  # @user_responses = format_user_responses
  # rescue ActiveRecord: :RecordInvalid => e
  # エラー時の処理
  # flash[:error] = "診断結果の保存に失敗しました"
  # redirect_to diagnoses_path

  private

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
