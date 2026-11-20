class ChangeUserIdNullInReviews < ActiveRecord::Migration[8.1]
  def change
    # user_idをnull許容に変更
    change_column_null :reviews, :user_id, true
  end
end
