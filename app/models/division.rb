class Division < ActiveRecord::Base
  has_many :teams,-> { order 'teams.win_perc desc'}
  belongs_to :season
  has_one :board_member

  def full_name
    "#{self.description} (#{self.season.description})"
  end
end
