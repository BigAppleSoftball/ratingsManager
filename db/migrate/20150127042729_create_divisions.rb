class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.integer :div_id
      t.integer :season_id
      t.integer :pool_id
      t.string :div_description
      t.integer :div_order
      t.string :standings
      t.integer :team_cap
      t.integer :waitlist_cap
      t.boolean :is_active

      t.timestamps
    end
  end
end
