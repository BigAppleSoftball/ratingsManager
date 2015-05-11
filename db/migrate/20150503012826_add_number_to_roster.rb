class AddNumberToRoster < ActiveRecord::Migration
  def change
    add_column :rosters, :jersey_number, :integer
  end
end
