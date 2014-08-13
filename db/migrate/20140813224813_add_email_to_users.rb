class AddEmailToUsers < ActiveRecord::Migration
  def change
    User.reset_column_information
    add_column :users, :email, :string
  end
end
