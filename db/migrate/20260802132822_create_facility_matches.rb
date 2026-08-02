class CreateFacilityMatches < ActiveRecord::Migration[7.2]
  def change
    create_table :facility_matches do |t|
      t.references :diagnosis_result, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true

      t.timestamps
    end

    # インデックスの追加とユニーク制約の設定
    add_index :facility_matches, [ :diagnosis_result_id, :facility_id ], unique: true
  end
end
