class CreateGameAttendances < ActiveRecord::Migration
  def change
    create_table :game_attendances do |t|
      t.integer :profile_id
      t.integer :game_id
      t.boolean :is_attending

      t.timestamps
    end
  end
end
