class AddScoresToFacilities < ActiveRecord::Migration[7.2]
  def change
    add_column :facilities, :cost_score, :decimal
    add_column :facilities, :medical_score, :decimal
    add_column :facilities, :location_score, :decimal
    add_column :facilities, :comfort_score, :decimal
  end
end
