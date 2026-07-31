class AddColumnsToDiagnosisResults < ActiveRecord::Migration[7.2]
  def change
    add_column :diagnosis_results, :category, :string
    add_column :diagnosis_results, :result_title, :string
    add_column :diagnosis_results, :result_description, :text
  end
end
