class MigrateExistingDiagnosisAnswers < ActiveRecord::Migration[7.2]
  def up
    # 既存の session_id ごとに Diagnosis を作成
    session_ids = DiagnosisAnswer.select(:session_id).distinct.pluck(:session_id)

    session_ids.each do |session_id|
      # Diagnosis を作成
      diagnosis = Diagnosis.create!(session_id: session_id)

      # その session_id の回答を diagnosis_id に紐づける
      DiagnosisAnswer.where(session_id: session_id).update_all(diagnosis_id: diagnosis.id)
    end
  end

  def down
    # ロールバック時の処理
    DiagnosisAnswer.update_all(diagnosis_id: nil)
    Diagnosis.destroy_all
  end
end
