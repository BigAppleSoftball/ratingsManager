class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :season_id
      t.integer :league_id
      t.integer :pool_id
      t.string :description
      t.datetime :date_start
      t.datetime :date_end

      t.timestamps
    end
  end
end
