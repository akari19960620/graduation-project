class AddFacilityScoreToFacilities < ActiveRecord::Migration[7.2]
  def change
    add_column :facilities, :facility_score, :decimal
  end
end
