class AddNameToHof < ActiveRecord::Migration
  def up
    add_column :hallof_famers, :first_name, :string
    add_column :hallof_famers, :last_name, :string
  end

  def down
    remove_column :hallof_famers, :first_name
    remove_column :hallof_famers, :last_name
  end
end
