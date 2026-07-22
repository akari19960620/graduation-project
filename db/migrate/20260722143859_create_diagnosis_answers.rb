class CreateDiagnosisAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnosis_answers do |t|
      t.references :diagnosis_question, null: false, foreign_key: true
      t.references :diagnosis_result, null: false, foreign_key: true
      t.integer :answer_value
      t.timestamps
    end
  end
end
