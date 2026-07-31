class CreateDiagnosisAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnosis_answers do |t|
      t.references :diagnosis_question, null: false, foreign_key: true
      t.references :diagnosis_option, null: false, foreign_key: true
      t.string :session_id, null: false
      t.timestamps
    end

    add_index :diagnosis_answers, [:session_id, :diagnosis_question_id], unique: true
  end
end
