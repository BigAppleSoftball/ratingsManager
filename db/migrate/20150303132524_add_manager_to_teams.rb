class AddManagerToTeams < ActiveRecord::Migration
  def up
    add_column :teams, :manager_profile_id, :integer
  end
  def down
    add_column :teams, :manager_profile_id
  end
end
