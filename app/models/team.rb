class Team < ActiveRecord::Base
  belongs_to :division
  has_one :home_games, :class_name => "Game", :foreign_key => 'home_team_id'
  has_one :away_games, :class_name => "Game", :foreign_key => 'away_team_id'

  has_many :sponsors, :through => :teams_sponsor
  has_many :profiles
  has_many :rosters
  has_many :teams_sponsor
end
