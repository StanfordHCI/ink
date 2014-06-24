class CreatePanels < ActiveRecord::Migration
  def change
    create_table :panels do |t|
      t.integer :page_id
      t.string :panel_name
      t.string :panel_description
      t.integer :display #true if greater than 0
      t.string :panel_type
      t.string :background_file
      t.timestamps
    end
  end
end
