class AddDefaultToRatings2122 < ActiveRecord::Migration
  def change
    change_column :asana_ratings, :rating_21, :integer, :default => 0
    change_column :asana_ratings, :rating_22, :integer, :default => 0
  end
end
