class AddWeightCategoryToDiagnosisOptions < ActiveRecord::Migration[7.2]
  def change
    add_column :diagnosis_options, :weight_category, :string
  end
end
