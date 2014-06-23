class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :user_id
      t.string :site_name
      t.string :description
      t.string :panel_name
      t.integer :display_panel_name #true if greater than 0
      t.string :panel_type
      t.string :background_file
      t.timestamps
    end
  end
end
