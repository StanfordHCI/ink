class AddCaptionToPanels < ActiveRecord::Migration
  def change
    add_column :panels, :caption, :text
  end
end
