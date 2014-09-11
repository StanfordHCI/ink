class CreateLeftPicTextpanels < ActiveRecord::Migration
  def change
    create_table :left_pic_textpanels do |t|
      t.references :page, index: true
      t.string :panel_name
      t.integer :display
      t.text :info
      t.string :file
      t.text :caption
      t.timestamps
    end
  end
end
