class CreateDiagnosisResults < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnosis_results do |t|
      t.integer :cost_score
      t.integer :facility_score
      t.integer :care_score
      t.timestamps
    end
  end
end
