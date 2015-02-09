class AddDisplayOrderToHof < ActiveRecord::Migration
  def up
    add_column :hallof_famers, :display_order, :integer
  end

  def down
    remove_column :hallof_famers, :display_order
  end
end
