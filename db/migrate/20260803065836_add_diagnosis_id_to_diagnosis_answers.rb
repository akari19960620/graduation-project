class AddDiagnosisIdToDiagnosisAnswers < ActiveRecord::Migration[7.2]
  def change
    # まず null: true でカラムを追加
    add_reference :diagnosis_answers, :diagnosis, foreign_key: true
  end
end
