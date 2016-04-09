class RenamePermissionsId < ActiveRecord::Migration
  def change
    rename_column :roles_permissions, :permissions_id, :permission_id
  end 
end
