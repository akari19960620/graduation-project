class RemoveOldIndexAndAddNewIndexToDiagnosisAnswers < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def up
    # 既存のユニークインデックスを削除（存在する場合のみ）
    if index_exists?(:diagnosis_answers, :session_id, name: "idx_on_session_id_diagnosis_question_id_2d63da7b8b")
      remove_index :diagnosis_answers, name: "idx_on_session_id_diagnosis_question_id_2d63da7b8b"
    end

    # 新しいユニークインデックスを追加（存在しない場合のみ）
    unless index_exists?(:diagnosis_answers, [:diagnosis_id, :diagnosis_question_id], name: "idx_on_diagnosis_id_diagnosis_question_id")
      add_index :diagnosis_answers, [:diagnosis_id, :diagnosis_question_id],
                unique: true,
                name: "idx_on_diagnosis_id_diagnosis_question_id",
                algorithm: :concurrently
    end
  end

  def down
    # ロールバック時の処理
    if index_exists?(:diagnosis_answers, [:diagnosis_id, :diagnosis_question_id], name: "idx_on_diagnosis_id_diagnosis_question_id")
      remove_index :diagnosis_answers, name: "idx_on_diagnosis_id_diagnosis_question_id"
    end
    
    # 元のインデックスを復元（存在しない場合のみ）
    unless index_exists?(:diagnosis_answers, :session_id, name: "idx_on_session_id_diagnosis_question_id_2d63da7b8b")
      add_index :diagnosis_answers, [:session_id, :diagnosis_question_id],
                unique: true,
                name: "idx_on_session_id_diagnosis_question_id_2d63da7b8b",
                algorithm: :concurrently
    end
  end
end