class DropFacilityMatches < ActiveRecord::Migration[7.2]
  def up
    drop_table :facility_matches, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
