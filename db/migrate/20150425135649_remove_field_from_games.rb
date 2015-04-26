class RemoveFieldFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :field
  end
end
