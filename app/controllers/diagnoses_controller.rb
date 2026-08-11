class DiagnosesController < ApplicationController
  rescue_from DiagnosisResultNotFoundError, with: :diagnosis_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @questions = DiagnosisQuestion.order(:display_order)
  end

  def create
    # ===== デバッグログ1: アクション開始 =====
    Rails.logger.info "===== create アクション開始 ====="
    Rails.logger.info "パラメータ: #{params.inspect}"
    # Form Object でバリデーション
    form = DiagnosisForm.new(diagnosis_params)
    # ===== デバッグログ2: バリデーション前 =====
    Rails.logger.info "form.valid? 実行前"
    unless form.valid?
      # ===== デバッグログ3: バリデーション失敗 =====
      Rails.logger.error "バリデーション失敗: #{form.errors.full_messages}"
      flash[:alert] = form.errors.full_messages.join(", ")
      redirect_to new_diagnosis_path
      return
    end

    # ===== デバッグログ4: バリデーション成功 =====
    Rails.logger.info "バリデーション成功"
    # Service Object で保存
    saver = DiagnosisAnswerSaver.new(current_session_id, form.question_answers)
    # ===== デバッグログ5: 保存前 =====
    Rails.logger.info "saver.save 実行前"
    Rails.logger.info "session_id: #{current_session_id}"
    Rails.logger.info "question_answers: #{form.question_answers.inspect}"
    result = saver.save
    # ===== デバッグログ6: 保存結果 =====
    Rails.logger.info "保存結果: #{result}" 

    if result
      diagnosis = Diagnosis.find_by(session_id: current_session_id)
      # ===== デバッグログ7: 診断データの取得 =====
      Rails.logger.info "診断データ: #{diagnosis.inspect}"
      if diagnosis
        # ===== デバッグログ8: リダイレクト前 =====
        Rails.logger.info "result_diagnosis_path へリダイレクト: #{result_diagnosis_path(diagnosis)}"
        redirect_to result_diagnosis_path(diagnosis), notice: "回答を保存しました"
      else
        # ===== デバッグログ9: 診断データが見つからない =====
        Rails.logger.error "診断データが見つかりませんでした"
        flash[:alert] = "診断データが見つかりませんでした"
        redirect_to new_diagnosis_path
      end
    else
      # ===== デバッグログ10: 保存失敗 =====
      Rails.logger.error "保存失敗: #{saver.error_message}"
      flash[:alert] = saver.error_message
      redirect_to new_diagnosis_path
    end
    # ===== デバッグログ11: アクション終了 =====
    Rails.logger.info "===== create アクション終了 ====="
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

  def diagnosis_not_found
    flash[:alert] = "診断を受けてください"
    redirect_to new_diagnosis_path
  end

  def record_not_found
    flash[:alert] = "診断結果が見つかりませんでした"
    redirect_to new_diagnosis_path
  end

  def current_session_id
    session.id.to_s
  end

  def assign_result_data(result_data)
    @answers = result_data[:answers]
    @scores = result_data[:scores]
    @result_category = result_data[:category]
    @diagnosis_result = result_data[:result]
    @recommended_facilities = result_data[:recommended_facilities]
  end

  def diagnosis_params
    question_keys = params.keys.select { |key| key.to_s.start_with?("question_") }
    params.permit(*question_keys)
  end
end
