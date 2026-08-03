class DiagnosesController < ApplicationController
  # レコードが見つからない場合のエラーハンドリング
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # 質問表示画面
  def new
    @questions = DiagnosisQuestion.includes(:diagnosis_options).order(:display_order)
  end
  # データベースに回答を保存
  def create
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

    # データの存在確認
    if result_data.nil?
      return redirect_to new_diagnosis_path, alert: "診断を受けてください"
    end
    
    # インスタンス変数への代入
    @answers = result_data[:answers] 
    @scores = result_data[:scores]
    @result_category = result_data[:category]
    @diagnosis_result = result_data[:result]
    @recommended_facilities = result_data[:recommended_facilities]
  end



  private

  def record_not_found
    flash[:alert] = "診断結果が見つかりませんでした"
    redirect_to diagnoses_path
  end

  # セッション ID の取得
  def current_session_id
    session.id.private_id
  end

  # 診断の回答データだけを安全に取得するためのストロングパラメータ
  def diagnosis_params
    params.permit(params.keys.select { |key| key.start_with?("question_") })
  end
end
