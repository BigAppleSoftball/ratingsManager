class ChangeBoardMembersLastNale < ActiveRecord::Migration
  def change
    rename_column :board_members, :last_nale, :last_name
  end
end
