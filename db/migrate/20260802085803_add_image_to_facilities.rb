class AddImageToFacilities < ActiveRecord::Migration[7.2]
  def change
    add_column :facilities, :image, :string
  end
end
