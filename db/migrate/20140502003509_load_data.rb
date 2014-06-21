class LoadData < ActiveRecord::Migration
  def up
    down
  end

  def down
    User.delete_all
  end
end
