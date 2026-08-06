class DiagnosisAnswerSaver
  attr_reader :error_message
  # インスタンス変数に必要なデータを格納（初期化）
  def initialize(session_id, diagnosis_params)
    @session_id = session_id
    @diagnosis_params = diagnosis_params
  end

  # 保存処理
  def save
    # トランザクションで処理を囲む（全て成功か、全て失敗）
    DiagnosisAnswer.transaction do
      diagnosis = find_or_create_diagnosis
      clear_previous_answers(diagnosis)
      # パラメータの中身をループ処理
      @diagnosis_params.each do |key, value|
        question_id = extract_question_id(key)
        option_id = value.to_i # 選択肢IDを文字列→整数に変換
        # 回答を保存するプライベートメソッドを呼び出す
        save_answer(diagnosis, question_id, option_id)
      end
    end
    true
  # エラーが発生した場合の処理
  rescue ActiveRecord::RecordInvalid => e
    @error_message = "回答の保存に失敗しました: #{e.message}"
    Rails.logger.error("DiagnosisAnswerSaver Error: #{e.message}")
    false
  rescue StandardError => e
    @error_message = '回答の保存に失敗しました'
    Rails.logger.error("DiagnosisAnswerSaver Error: #{e.message}")
    false
  end

  private

  # Diagnosis レコードを取得または作成
  def find_or_create_diagnosis
    Diagnosis.find_or_create_by!(session_id: @session_id)
  end

  # パラメータのキーから質問IDを抽出
  def extract_question_id(key)
    key.to_s.gsub('question_', '').to_i
  end

  def clear_previous_answers(diagnosis)
    diagnosis.diagnosis_answers.destroy_all
  end

  def save_answer(diagnosis, question_id, option_id)
    diagnosis.diagnosis_answers.create!(
      diagnosis_question_id: question_id,
      diagnosis_option_id: option_id
    )
  end
end
