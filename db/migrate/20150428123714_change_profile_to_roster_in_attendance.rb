class ChangeProfileToRosterInAttendance < ActiveRecord::Migration
  def change
    rename_column :game_attendances, :profile_id, :roster_id
  end
end
