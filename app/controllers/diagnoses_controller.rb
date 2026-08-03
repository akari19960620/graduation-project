class DiagnosesController < ApplicationController
  rescue_from DiagnosisResultNotFoundError, with: :diagnosis_not_found
  # レコードが見つからない場合のエラーハンドリング
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # 質問表示画面
  def new
    @questions = DiagnosisQuestion.includes(:diagnosis_options).order(:display_order)
  end
  # データベースに回答を保存
  def create
    unless all_questions_answered?
      flash[:alert] = "すべての質問に回答してください"
      redirect_to new_diagnosis_path and return
    end

    clear_previous_diagnoses # 過去の診断結果を削除
    # DiagnosisAnswerSaverインスタンスの生成
    saver = DiagnosisAnswerSaver.new(current_session_id, diagnosis_params)
    # 保存処理の実行
    if saver.save
      redirect_to result_diagnoses_path, notice: "回答を保存しました"
    else
      flash[:alert] = "回答の保存に失敗しました"
      redirect_to new_diagnosis_path
    end
  end

  # 診断結果の表示
  def result
    # DiagnosisResultFetcherインスタンスの生成
    fetcher = DiagnosisResultFetcher.new(current_session_id)
    result_data = fetcher.fetch # 診断結果データの取得

    # 診断結果が見つからない場合、例外を発生させる
    raise DiagnosisResultNotFoundError if result_data.nil?

    # 正常時のみ実行される（例外が発生した場合は rescue_from で処理）
    assign_result_data(result_data)
  end



  private

  def all_questions_answered?
    question_count = DiagnosisQuestion.count
    answered_count = diagnosis_params.keys.count { |k| k.start_with?("question_") }
    answered_count == question_count
  end

  # 診断が見つからない場合のエラーハンドリング
  def diagnosis_not_found
    flash[:alert] = "診断を受けてください"
    redirect_to new_diagnosis_path
  end

  def record_not_found
    flash[:alert] = "診断結果が見つかりませんでした"
    redirect_to new_diagnosis_path
  end

  # 診断セッションのクリア
  def clear_diagnosis_session
    session.delete(:diagnosis_answers)
  end

  # 過去の診断結果を削除（追加）
  def clear_previous_diagnoses
    # セッション ID に紐づく過去の診断結果を削除
    Diagnosis.where(session_id: current_session_id).destroy_all
  end

  # セッション ID の取得
  def current_session_id
    session.id.private_id
  end

  # 診断結果データをインスタンス変数に代入
  def assign_result_data(result_data)
    @answers = result_data[:answers]
    @scores = result_data[:scores]
    @result_category = result_data[:category]
    @diagnosis_result = result_data[:result]
    @recommended_facilities = result_data[:recommended_facilities]
  end

  # 診断の回答データだけを安全に取得するためのストロングパラメータ
  def diagnosis_params
    params.permit(params.keys.select { |key| key.start_with?("question_") })
  end
end
