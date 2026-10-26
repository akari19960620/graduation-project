class SorceryCore < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :password_digest, :string
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string
  end
end
