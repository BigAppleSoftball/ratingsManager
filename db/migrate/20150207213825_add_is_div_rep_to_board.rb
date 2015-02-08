class AddIsDivRepToBoard < ActiveRecord::Migration
  def up
    add_column :board_members, :is_division_rep, :boolean
  end
 
  def down
    remove_column :board_members, :is_division_rep
  end
end
