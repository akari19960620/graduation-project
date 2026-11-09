class ChangeUserIdNullInDiagnoses < ActiveRecord::Migration[7.2]
  def change
    change_column_null :diagnoses, :user_id, true
  end
end
