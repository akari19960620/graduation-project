class CreateDiagnosisOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnosis_options do |t|
      t.references :diagnosis_question, null: false, foreign_key: true
      t.string :option_text, null: false
      t.integer :weight_value, null: false
      t.integer :display_order, null: false, default: 0

      t.timestamps
    end
  end
end
