class AsanaRating < ActiveRecord::Base
  belongs_to :profile 

  # Display total rating
  def total
    self.rating_1 +
    self.rating_2 +
    self.rating_3 +
    self.rating_4 +
    self.rating_5 +
    self.rating_6 +
    self.rating_7 +
    self.rating_8 +
    self.rating_9 +
    self.rating_10 +
    self.rating_11 +
    self.rating_12 +
    self.rating_13 +
    self.rating_14 +
    self.rating_15 +
    self.rating_16 +
    self.rating_17 +
    self.rating_18 +
    self.rating_19 +
    self.rating_20 
  end
end
