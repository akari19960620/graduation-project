class RemoveComfortScoreFromFacilities < ActiveRecord::Migration[7.2]
  def change
    remove_column :facilities, :comfort_score, :decimal
  end
end
