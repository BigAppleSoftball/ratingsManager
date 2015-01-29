class Division < ActiveRecord::Base
  has_many :teams,-> { order 'teams.win_perc desc'}
  belongs_to :season
end
