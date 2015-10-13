class MotionTeam < ActiveRecord::Base
  belongs_to :team
  belongs_to :motion
end
