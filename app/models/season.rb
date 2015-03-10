class Season < ActiveRecord::Base
  has_many :divisions

  def divisions
    Division.where(:season_id => self.id)
  end

  def is_editable_season?
    self.is_active
  end
end
