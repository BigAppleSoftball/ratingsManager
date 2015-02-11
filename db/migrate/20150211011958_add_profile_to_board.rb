class AddProfileToBoard < ActiveRecord::Migration
  def up
    add_column :board_members, :profile_id, :integer
  end

  def down
    remove_column :board_members, :profile_id
  end
end
