class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer :selectpanel_id
      t.string :selectpanel_type
      t.string :option_title
      t.string :file
      t.text :info
      t.timestamps
    end
  end
end
