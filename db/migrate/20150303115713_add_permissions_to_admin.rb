class AddPermissionsToAdmin < ActiveRecord::Migration
  def up
    add_column :board_members, :division_id, :integer
    add_column :board_members, :is_league_admin, :boolean
  end

  def down
    remove_column :board_members, :division_id
    remove_column :board_members, :is_league_admin
  end
end
