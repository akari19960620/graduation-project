class ChangeColumnDiagnosisIdNotNullOnDiagnosisAnswers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :diagnosis_answers, :diagnosis_id, false
  end
end
