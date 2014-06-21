class AddLoginToUsers < ActiveRecord::Migration
  def change
    User.reset_column_information
    add_column :users, :login, :string
  end
end
