class AddRatings2122ToAsanaRatings < ActiveRecord::Migration
  def change
    add_column :asana_ratings, :rating_21, :integer
    add_column :asana_ratings, :rating_22, :integer
  end
end
