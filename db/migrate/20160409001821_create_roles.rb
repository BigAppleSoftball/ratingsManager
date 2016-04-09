class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.integer :season_id
      t.integer :division_id
      t.integer :team_id

      t.timestamps
    end
  end
end
