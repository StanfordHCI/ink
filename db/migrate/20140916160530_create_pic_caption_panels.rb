class CreatePicCaptionPanels < ActiveRecord::Migration
  def change
    create_table :pic_caption_panels do |t|
      t.references :page, index: true
      t.string :panel_name
      t.integer :display
      t.text :caption
      t.string :file
      t.timestamps
    end
  end
end
