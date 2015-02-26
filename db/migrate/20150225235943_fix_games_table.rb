class FixGamesTable < ActiveRecord::Migration
  def change
    remove_column :games, :integer
    change_column :games, :home_team_id, :integer
  end
end
