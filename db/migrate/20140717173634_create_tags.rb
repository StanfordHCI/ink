class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :panel_id
      t.string :panel_type
      t.string :name
      t.integer :value
      t.timestamps
    end
  end
end
