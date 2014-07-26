class CreatePanels < ActiveRecord::Migration
  def change
    create_table :panels do |t|
      t.references :page, index: true
      t.string :panel_name
      t.text :info
      t.integer :display #true if greater than 0
      t.string :type
      t.string :file
      t.timestamps
    end
  end
end
