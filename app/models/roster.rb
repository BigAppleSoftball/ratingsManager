class Roster < ActiveRecord::Base
  belongs_to :profile
  belongs_to :team
end
