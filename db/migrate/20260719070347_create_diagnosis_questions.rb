class CreateDiagnosisQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnosis_questions do |t|
      t.text :question_text, null: false
      t.integer :question_type, null: false

      t.timestamps
    end
  end
end