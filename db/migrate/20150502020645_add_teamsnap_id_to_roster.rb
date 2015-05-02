class AddTeamsnapIdToRoster < ActiveRecord::Migration
  def change
    add_column :rosters, :teamsnap_id, :integer
  end
end
