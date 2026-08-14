class MigrateExistingDiagnosisAnswers < ActiveRecord::Migration[7.2]
  def up
    # session_id カラムが存在する場合のみ実行
    if column_exists?(:diagnosis_answers, :session_id)
      # 既存の session_id ごとに Diagnosis を作成
      session_ids = DiagnosisAnswer.select(:session_id).distinct.pluck(:session_id)

      session_ids.each do |session_id|
        # Diagnosis を作成
        diagnosis = Diagnosis.create!(session_id: session_id)

        # その session_id の回答を diagnosis_id に紐づける
        DiagnosisAnswer.where(session_id: session_id).update_all(diagnosis_id: diagnosis.id)
      end
    else
      # session_id カラムが存在しない場合はスキップ
      say "session_id column does not exist. Skipping migration."
    end
  end

  def down
    # ロールバック時の処理
    if column_exists?(:diagnosis_answers, :diagnosis_id)
      DiagnosisAnswer.update_all(diagnosis_id: nil)
    end
    Diagnosis.destroy_all
  end
end
