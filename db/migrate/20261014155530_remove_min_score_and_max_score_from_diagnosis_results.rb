class RemoveMinScoreAndMaxScoreFromDiagnosisResults < ActiveRecord::Migration[7.2]
  def change
    remove_column :diagnosis_results, :min_score, :integer
    remove_column :diagnosis_results, :max_score, :integer
  end
end
