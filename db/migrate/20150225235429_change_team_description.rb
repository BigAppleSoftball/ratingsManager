class ChangeTeamDescription < ActiveRecord::Migration
  def up
    rename_column :teams, :team_desc, :description
  end

  def down
    rename_column :teams, :description, :team_desc
  end
end
