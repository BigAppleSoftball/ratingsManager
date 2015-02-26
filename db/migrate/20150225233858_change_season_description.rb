class ChangeSeasonDescription < ActiveRecord::Migration
  def up
    rename_column :seasons, :season_desc, :description
  end

  def down
    rename_column :seasons, :description, :season_desc
  end
end
