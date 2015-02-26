class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :day_id
      t.datetime :start_time
      t.string :home_team_id
      t.string :integer
      t.integer :away_team_id
      t.boolean :is_flip
      t.integer :field
      t.integer :home_score
      t.integer :away_score
      t.boolean :is_rainout
      t.boolean :is_active

      t.timestamps
    end
  end
end
