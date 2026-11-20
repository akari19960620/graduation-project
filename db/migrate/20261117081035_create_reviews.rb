class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true
      t.integer :cost_rating
      t.integer :facility_rating
      t.integer :medical_rating
      t.text :comment

      t.timestamps
    end
  end
end
