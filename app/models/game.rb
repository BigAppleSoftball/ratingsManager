class Game < ActiveRecord::Base
  belongs_to :home_team, :class_name => "Team"
  belongs_to :away_team, :class_name => "Team"
  belongs_to :field
  has_many :game_attendances

  def is_played?
    !(self.away_score.nil? || self.home_score.nil?)
  end

  def is_tied?
    (self.away_score == self.home_score)
  end

  def is_winner?(team_id)
    if self.is_tied? || !self.is_played?
      false
    else
      if (self.away_score > self.home_score)
        return team_id == self.away_team_id
      elsif (self.away_score < self.home_score)
        return team_id == self.home_team_id
      end
      false
    end
  end
end
