class Rating < ActiveRecord::Base
  belongs_to :profile

  # calculating the total throwing rating
  def throwing_total
    self.rating_1 +
    self.rating_2 +
    self.rating_3 +
    self.rating_4 +
    self.rating_5
  end

  # calculating the total fielding rating
  def fielding_total
    self.rating_6 +
    self.rating_7 +
    self.rating_8 +
    self.rating_9 +
    self.rating_10 +
    self.rating_11 +
    self.rating_12 +
    self.rating_13 +
    self.rating_14
  end

  # calulate the baserunning total
  def baserunning_total
    self.rating_15 +
    self.rating_16 +
    self.rating_17 +
    self.rating_18
  end

  # calculating the hitting total
  def hitting_total
    self.rating_19 +
    self.rating_20 +
    self.rating_21 +
    self.rating_22 +
    self.rating_23 +
    self.rating_24 +
    self.rating_25 +
    self.rating_26 +
    self.rating_27
  end

  # total rating
  def total
    throwing_total +
    fielding_total +
    baserunning_total +
    hitting_total
  end
end
