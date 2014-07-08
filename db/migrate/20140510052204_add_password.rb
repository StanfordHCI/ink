class AddPassword < ActiveRecord::Migration
  def change
    User.reset_column_information
    add_column :users, :password_digest, :string
    add_column :users, :salt, :string
  end
end
