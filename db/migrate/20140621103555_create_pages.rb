class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :user_id
      t.string :site_name
      t.text :description
      t.integer :display_description
      t.timestamps
    end
  end
end
