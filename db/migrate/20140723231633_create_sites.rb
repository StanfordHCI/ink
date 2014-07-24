class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.integer :page_id
      t.timestamps
    end
  end
end
