class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.integer :team_id
      t.integer :profile_id
      t.datetime :date_created
      t.datetime :date_approved
      t.datetime :date_updated
      t.boolean :is_approved
      t.boolean :is_player
      t.boolean :is_rep
      t.boolean :is_manager
      t.boolean :is_active
      t.boolean :is_confirmed

      t.timestamps
    end
  end
end
