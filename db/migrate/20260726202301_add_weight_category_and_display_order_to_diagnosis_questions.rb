class AddWeightCategoryAndDisplayOrderToDiagnosisQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :diagnosis_questions, :weight_category, :string
    add_column :diagnosis_questions, :display_order, :integer, null: false, default: 0
  end
end
