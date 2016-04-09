class CreateRolesPermissions < ActiveRecord::Migration
  def change
    create_table :roles_permissions do |t|
      t.integer :role_id
      t.integer :permissions_id

      t.timestamps
    end
  end
end
