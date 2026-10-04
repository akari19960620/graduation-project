class AddMinScoreAndMaxScoreToDiagnosisResults < ActiveRecord::Migration[7.2]
  def change
    add_column :diagnosis_results, :min_score, :integer
    add_column :diagnosis_results, :max_score, :integer
  end
end
