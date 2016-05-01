class AddIsCoedToDivision < ActiveRecord::Migration
  def up
    add_column :divisions, :is_coed, :boolean
  end
 
  def down
    remove_column :divisions, :is_coed
  end
end
