class AddSourceToPanels < ActiveRecord::Migration
  def change
    add_column :panels, :source, :string
  end
end
