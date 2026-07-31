class RemoveScoresFromDiagnosisResults < ActiveRecord::Migration[7.2]
  def change
    remove_column :diagnosis_results, :cost_score, :integer
    remove_column :diagnosis_results, :facility_score, :integer
    remove_column :diagnosis_results, :care_score, :integer
  end
end
