class CreateFacilities < ActiveRecord::Migration[7.2]
  def change
    create_table :facilities do |t|
      t.integer :monthly_fee_min
      t.integer :monthly_fee_max
      t.integer :capacity
      t.string :room_type
      t.integer :care_level
      t.string :services
      t.string :features

      t.timestamps
    end
  end
end
