class Team < ActiveRecord::Base
  belongs_to :division, :foreign_key => :division_id
end
