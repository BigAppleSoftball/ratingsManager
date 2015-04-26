class AddCurrentAndUpcomingToSeason < ActiveRecord::Migration
  def up
    add_column :seasons, :is_active, :boolean
  end

  def down
    remove_column :seasons, :is_active
  end
end
