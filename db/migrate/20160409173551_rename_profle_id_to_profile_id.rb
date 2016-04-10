class RenameProfleIdToProfileId < ActiveRecord::Migration
  def change
    rename_column :profile_roles, :profle_id, :profile_id
  end
end
