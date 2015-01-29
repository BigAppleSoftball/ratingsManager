class Division < ActiveRecord::Base
  has_many :teams,-> { order 'teams.win_perc desc'}, :primary_key => :div_id, :foreign_key => :division_id
  belongs_to :season, :foreign_key => :season_id
end
