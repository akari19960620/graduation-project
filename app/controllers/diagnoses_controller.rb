class DiagnosesController < ApplicationController
  skip_before_action :require_login, only: %i[new create result]

  CATEGORY_ORDER = %w[
    特別養護老人ホーム
    有料老人ホーム
    グループホーム
    ケアハウス
    高齢者向け住宅
  ].freeze

  rescue_from DiagnosisResultNotFoundError, with: :diagnosis_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @questions = DiagnosisQuestion.order(:display_order)
  end

  def create
    # Form Object でバリデーション
    form = DiagnosisForm.new(diagnosis_params)
    unless form.valid?
      flash[:danger] = form.errors.full_messages.join(", ")
      redirect_to new_diagnosis_path
      return
    end

    # Service Object で保存
    saver = DiagnosisAnswerSaver.new(current_session_id, form.question_answers, current_user)
    result = saver.save

    if result
      diagnosis = Diagnosis.find_by(session_id: current_session_id)
      if diagnosis
        redirect_to result_diagnosis_path(diagnosis), success: "回答を保存しました"
      else
        flash[:danger] = "診断データが見つかりませんでした"
        redirect_to new_diagnosis_path
      end
    else
      flash[:danger] = saver.error_message
      redirect_to new_diagnosis_path
    end
  end

 def result
  # URLのIDに加えて、session_idも一致するものだけを取得する→他人の結果を見れないように。
  @diagnosis = Diagnosis.find_by(id: params[:id], session_id: current_session_id)
  # find_byは該当レコードが見つからない場合nilを返すので、診断結果が見つからない場合は例外を発生させる
  raise ActiveRecord::RecordNotFound if @diagnosis.nil?
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
    flash[:danger] = "診断を受けてください"
    redirect_to new_diagnosis_path
  end

  def record_not_found
    flash[:danger] = "診断結果が見つかりませんでした"
    redirect_to new_diagnosis_path
  end

  def current_session_id
  # セッションIDが存在しない場合は生成する
  session[:session_id] ||= SecureRandom.uuid
  session[:session_id]
end

  def assign_result_data(result_data)
    @answers = result_data[:answers]
    @scores = result_data[:scores]
    @result_category = result_data[:category]
    @percentages = result_data[:percentages]
    @diagnosis_result = result_data[:result]
    # facility_type の順序を CATEGORY_ORDER に従って固定する
    @recommended_facilities = result_data[:recommended_facilities].sort_by do |facility|
      CATEGORY_ORDER.index(facility.facility_type) || CATEGORY_ORDER.size
    end
    Rails.logger.debug "並び替え後の施設タイプ順: #{@recommended_facilities.map(&:facility_type)}"
  end

  def diagnosis_params
    question_keys = params.keys.select { |key| key.to_s.start_with?("question_") }
    params.permit(*question_keys)
  end
end
