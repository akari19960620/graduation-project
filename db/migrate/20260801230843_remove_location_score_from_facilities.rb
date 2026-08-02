class RemoveLocationScoreFromFacilities < ActiveRecord::Migration[7.2]
  def change
    remove_column :facilities, :location_score, :decimal
  end
end
