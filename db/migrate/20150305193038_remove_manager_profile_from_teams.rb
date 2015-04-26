class RemoveManagerProfileFromTeams < ActiveRecord::Migration
  def up
    remove_column :teams, :manager_profile_id
  end
  def down
    add_column :teams, :manager_profile_id, :integer
  end
end
