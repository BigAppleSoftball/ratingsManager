class AddTeamsnapIdToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :teamsnap_id, :integer
  end
end
