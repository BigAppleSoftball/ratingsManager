class Team < ActiveRecord::Base
  belongs_to :division
  has_one :home_games, :class_name => "Game", :foreign_key => 'home_team_id', dependent: :nullify
  has_one :away_games, :class_name => "Game", :foreign_key => 'away_team_id', dependent: :nullify
  has_many :sponsors, :through => :teams_sponsor
  has_many :profiles
  has_many :rosters, dependent: :destroy
  has_many :teams_sponsor, dependent: :destroy

  def managers
    Roster.where(:team_id => self.id, :is_manager => true)
  end

  def reps
    Roster.where(:team_id => self.id, :is_rep => true)
  end

  def full_name
    "#{self.name} <span class='team-season'>(#{self.division.description} #{self.division.season.description})</span>"
  end

end
