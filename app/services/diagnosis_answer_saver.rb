class DiagnosisAnswerSaver
  # インスタンス変数に必要なデータを格納（初期化）
  def initialize(session_id, diagnosis_params)
    @session_id = session_id
    @diagnosis_params = diagnosis_params
  end

  # 保存処理
  def save
    # トランザクションで処理を囲む（全て成功か、全て失敗）
    DiagnosisAnswer.transaction do
      clear_previous_diagnoses # 過去の診断結果を削除
      diagnosis = find_or_create_diagnosis
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
    Rails.logger.error("診断解答の保存に失敗しました: #{e.message}")
    false
  end

  private

   # 過去の診断結果を削除（追加）
  def clear_previous_diagnoses
    # セッション ID に紐づく過去の診断結果を削除
    Diagnosis.where(session_id: @session_id).destroy_all
  end

  # Diagnosis レコードを取得または作成
  def find_or_create_diagnosis
    Diagnosis.find_or_create_by!(session_id: @session_id)
  end

  # パラメータのキーから質問IDを抽出
  def extract_question_id(key)
    key.split("_").last.to_i
  end

  # 回答の保存
  def save_answer(diagnosis, question_id, option_id)
    # 既存のレコードを探し、なければ新しいインスタンスを作成
    answer = DiagnosisAnswer.find_or_initialize_by(
      diagnosis_id: diagnosis.id,
      diagnosis_question_id: question_id
    )
    # 選択肢IDを設定
    answer.diagnosis_option_id = option_id
    # データベースに保存
    answer.save!
  end
end
