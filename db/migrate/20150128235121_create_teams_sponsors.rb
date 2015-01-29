class CreateTeamsSponsors < ActiveRecord::Migration
  def change
    create_table :teams_sponsors do |t|
      t.integer :team_id
      t.integer :sponsor_id
      t.boolean :is_active
      t.integer :link_id

      t.timestamps
    end
  end
end
