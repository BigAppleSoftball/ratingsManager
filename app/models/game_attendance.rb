class GameAttendance < ActiveRecord::Base
  belongs_to :roster
  belongs_to :game
end
