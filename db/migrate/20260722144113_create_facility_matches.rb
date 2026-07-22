class CreateFacilityMatches < ActiveRecord::Migration[7.2]
  def change
    create_table :facility_matches do |t|
      t.references :diagnosis_result, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true
      t.integer :match_score
      t.timestamps
    end
  end
end
