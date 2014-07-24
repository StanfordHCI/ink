class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :page, index: true
      t.string :panel_name
      t.integer :display
      t.text :info
      t.string :file
      t.timestamps
    end
  end
end
