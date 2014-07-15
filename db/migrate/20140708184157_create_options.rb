class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.references :s_selectpanel, index: true
      t.string :option_title
      t.string :icon
      t.timestamps
    end
  end
end
