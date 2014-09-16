class CreateQuotePanels < ActiveRecord::Migration
  def change
    create_table :quote_panels do |t|
      t.references :page, index: true
      t.string :panel_name
      t.integer :display
      t.text :info
      t.string :source
      t.string :file
      t.timestamps
    end
  end
end
