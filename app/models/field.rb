class Field < ActiveRecord::Base
  belongs_to :park
  has_many :games, dependent: :nullify
end
