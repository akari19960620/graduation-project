class CreateDiagnoses < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnoses do |t|
      t.string :session_id, null: false
      t.references :diagnosis_result, foreign_key: true  # 外部キー制約付き
      t.integer :status, default: 0, null: false
      t.datetime :completed_at

      t.timestamps
    end

    add_index :diagnoses, :session_id, unique: true
    add_index :diagnoses, :status
  end
end
