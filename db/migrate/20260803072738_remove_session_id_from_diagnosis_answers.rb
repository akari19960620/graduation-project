class RemoveSessionIdFromDiagnosisAnswers < ActiveRecord::Migration[7.2]
  def change
    # インデックスを削除（既に存在チェックあり）
    remove_index :diagnosis_answers, :session_id, if_exists: true

    # session_id カラムが存在する場合のみ削除
    if column_exists?(:diagnosis_answers, :session_id)
      remove_column :diagnosis_answers, :session_id, :string
    else
      say "session_id column does not exist. Skipping removal."
    end
  end
end
