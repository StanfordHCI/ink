class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :user_id
      t.string :site_name
      t.string :description
      t.integer :display_panel_name #true if greater than 0
      t.string :panel_type
      t.background :background_file
      t.timestamps
    end
  end
end
