class AddMissingColumnsToFacilities < ActiveRecord::Migration[7.2]
  def change
    add_column :facilities, :name, :string
    add_column :facilities, :facility_type, :string
    add_column :facilities, :address, :string
    add_column :facilities, :phone, :string
    add_column :facilities, :website_url, :string
  end
end
