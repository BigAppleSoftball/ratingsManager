class Season < ActiveRecord::Base
  has_many :divisions, :primary_key => :season_id, :foreign_key => :season_id
end
