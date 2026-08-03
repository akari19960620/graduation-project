class RemoveSessionIdFromDiagnosisAnswers < ActiveRecord::Migration[7.2]
  def change
    # インデックスを削除（もし存在する場合）
    remove_index :diagnosis_answers, :session_id, if_exists: true

    # session_id カラムを削除
    remove_column :diagnosis_answers, :session_id, :string
  end
end
