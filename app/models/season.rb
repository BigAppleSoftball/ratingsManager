class Season < ActiveRecord::Base
  has_many :divisions

  def divisions
    Division.where(:season_id => self.id)
  end
end
