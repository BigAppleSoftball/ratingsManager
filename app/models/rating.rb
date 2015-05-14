

class Rating < ActiveRecord::Base
  belongs_to :profile
  validate :ratings_cannot_be_out_of_order
  validates :profile_id, presence: true

  #
  # Validating fielding, can't rank levels out of order
  # 
  def ratings_cannot_be_out_of_order
    check_ratings(throwing_ratings, 'throwing')
    check_ratings(fielding_ratings, 'fielding')
    check_ratings(running_ratings, 'running')
    check_ratings(hitting_ratings, 'hitting')
  end

  #
  # Reverse loops through the ratings to make sure we 
  # don't have ratings levels that are ranked out of order
  # i.e. can't be level 1 and a level 3 but NOT a level 2
  #
  def check_ratings(ratings, type)
    current_value = 0

    ratings.reverse_each do |rating|
      if (rating < current_value)
        errors.add(:rating, "Cannot rate #{type} levels out of order")
      else
        current_value = rating
      end
    end

  end

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

  def throwing_ratings
    throwing = Array.new
    throwing.push(self.rating_1)
    throwing.push(self.rating_2)
    throwing.push(self.rating_3)
    throwing.push(self.rating_4)
    throwing.push(self.rating_5)
  end

  def fielding_ratings
    fielding = Array.new
    fielding.push(self.rating_6)
    fielding.push(self.rating_7)
    fielding.push(self.rating_8)
    fielding.push(self.rating_9)
    fielding.push(self.rating_10)
    fielding.push(self.rating_11)
    fielding.push(self.rating_12)
    fielding.push(self.rating_13)
    fielding.push(self.rating_14)
  end

  def running_ratings
    running = Array.new
    running.push(self.rating_15)
    running.push(self.rating_16)
    running.push(self.rating_17)
    running.push(self.rating_18)
  end

  def hitting_ratings
    hitting = Array.new
    hitting.push(self.rating_19)
    hitting.push(self.rating_20)
    hitting.push(self.rating_21)
    hitting.push(self.rating_22)
    hitting.push(self.rating_23)
    hitting.push(self.rating_24)
    hitting.push(self.rating_25)
    hitting.push(self.rating_26)
    hitting.push(self.rating_27)
  end
end


