class CreateMotionTeams < ActiveRecord::Migration
  def change
    create_table :motion_teams do |t|
      t.integer :team_id
      t.integer :motion_id

      t.timestamps
    end
  end
end
