class CreateMSelectpanels < ActiveRecord::Migration
  def change
    create_table :m_selectpanels do |t|
      t.references :page, index: true
      t.string :panel_name
      t.integer :display
      t.text :info
      t.timestamps
    end
  end
end
