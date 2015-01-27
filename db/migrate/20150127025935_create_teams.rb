class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :division_id
      t.string :long_name
      t.integer :stat_loss
      t.integer :stat_win
      t.integer :stat_play
      t.integer :stat_pt_allowed
      t.integer :stat_pt_scored
      t.integer :stat_tie
      t.integer :teamsnap_id
      t.text :team_desc
      t.string :name

      t.timestamps
    end
  end
end
