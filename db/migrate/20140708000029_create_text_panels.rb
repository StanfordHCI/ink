class CreateTextPanels < ActiveRecord::Migration
  def change
    create_table :text_panels do |t|
      t.references :page, index: true
      t.string :panel_name
      t.integer :display
      t.text :info
      t.timestamps
    end
  end
end
