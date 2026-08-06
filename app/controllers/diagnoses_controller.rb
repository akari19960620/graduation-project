class DiagnosesController < ApplicationController
  rescue_from DiagnosisResultNotFoundError, with: :diagnosis_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @questions = DiagnosisQuestion.order(:display_order)
  end
 
  def create
    # Form Object でバリデーション
    form = DiagnosisForm.new(diagnosis_params)

    unless form.valid?
      flash[:alert] = form.errors.full_messages.join(', ')
      redirect_to new_diagnosis_path
      return
    end

    # Service Object で保存
    saver = DiagnosisAnswerSaver.new(current_session_id, form.question_answers)
    result = saver.save

    if result
      # 既存の診断データを取得（find_or_create_by を使用しているため）
      diagnosis = Diagnosis.find_by!(session_id: current_session_id)
      redirect_to result_diagnosis_path(diagnosis), notice: '回答を保存しました'
    else
      flash[:alert] = saver.error_message
      redirect_to new_diagnosis_path
    end
  end

  def result
    # URLのIDから診断データを取得
    @diagnosis = Diagnosis.find(params[:id])
    
    # DiagnosisResultFetcherで診断結果を取得
    fetcher = DiagnosisResultFetcher.new(@diagnosis.id)
    result_data = fetcher.fetch

    # 診断結果が見つからない場合、例外を発生させる
    raise DiagnosisResultNotFoundError if result_data.nil?

    # 診断結果データをインスタンス変数に代入
    assign_result_data(result_data)
  end

  private

  # 診断が見つからない場合のエラーハンドリング
  def diagnosis_not_found
    flash[:alert] = "診断を受けてください"
    redirect_to new_diagnosis_path
  end

  def record_not_found
    flash[:alert] = "診断結果が見つかりませんでした"
    redirect_to new_diagnosis_path
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