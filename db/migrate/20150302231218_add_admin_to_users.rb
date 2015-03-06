class AddAdminToUsers < ActiveRecord::Migration
  def up
    add_column :profiles, :is_admin, :boolean
  end

  def down
    remove_column :profiles, :is_admin, :boolean
  end
end
