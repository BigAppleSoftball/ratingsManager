class AsanaRating < ActiveRecord::Base
  belongs_to :profile 
  # can't have a rating without a profile
  validates :profile_id, presence: true

  def classification
    if self.total <= 30
      'E'
    elsif self.total > 30 && self.total <= 50
      'D'
    elsif self.total > 50 && self.total <= 69
      'C'
    elsif self.total > 69 && self.total <= 90
      'B'
    elsif self.total > 90
      'A'
    else
      'N/A'
    end
  end

  def throwing_total
    self.rating_1 +
    self.rating_2 +
    self.rating_3 +
    self.rating_4 
  end

  def fielding_total
    self.rating_5 +
    self.rating_6 +
    self.rating_7 +
    self.rating_8 +
    self.rating_9 +
    self.rating_10
  end

  def batting_total
    self.rating_11 +
    self.rating_12 +
    self.rating_13 +
    self.rating_14 +
    self.rating_15 +
    self.rating_16
  end

  def baserunning_total
    self.rating_17 +
    self.rating_18 +
    self.rating_19
  end

  def fundamentals_total
    self.rating_20
  end

  def experience_total
    self.rating_21 +
    self.rating_22
  end

  # Display total rating
  def total
    self.throwing_total     +
    self.fielding_total     +
    self.batting_total      +
    self.baserunning_total  +
    self.fundamentals_total +
    self.experience_total
  end

  def rank
    total = self.total
    if total <= 50
      'D'
    elsif total > 50 && total < 70
      'C'
    elsif total >= 70 && total <= 90
      'B'
    elsif self.total > 90
      'A'
    end
  end
end
