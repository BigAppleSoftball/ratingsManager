class AddTeamsnapNameIdToBoardMembers < ActiveRecord::Migration
    def up
    add_column :board_members, :teamsnap_id, :integer
    add_column :board_members, :teamsnap_name, :string
  end

  def down
    remove_column :board_members, :teamsnap_id
    remove_column :board_members, :teamsnap_name
  end
end
