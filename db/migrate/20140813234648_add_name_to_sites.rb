class AddNameToSites < ActiveRecord::Migration
  def change
    Site.reset_column_information
    add_column :sites, :name, :string
  end
end
