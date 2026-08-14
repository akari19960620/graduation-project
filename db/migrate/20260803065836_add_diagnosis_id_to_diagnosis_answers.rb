class AddDiagnosisIdToDiagnosisAnswers < ActiveRecord::Migration[7.2]
  def change
    # まず null: true でカラムを追加
    add_reference :diagnosis_answers, :diagnosis, foreign_key: true

    # 既存のユニークインデックスを削除
    if index_exists?(:diagnosis_answers, name: "idx_on_session_id_diagnosis_question_id_2d63da7b8b")
      remove_index :diagnosis_answers, name: "idx_on_session_id_diagnosis_question_id_2d63da7b8b"
    end

    # 新しいユニークインデックスを追加
    add_index :diagnosis_answers, [ :diagnosis_id, :diagnosis_question_id ],
              unique: true,
              name: "idx_on_diagnosis_id_diagnosis_question_id"
  end
end
