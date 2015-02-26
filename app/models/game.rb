class Game < ActiveRecord::Base
  belongs_to :team, :class_name => 'Team', :foreign_key => 'home_team_id'
end
