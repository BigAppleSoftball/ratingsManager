class AddRatingsToAsanaRatings < ActiveRecord::Migration
  def change
    add_column :asana_ratings, :rating_13, :integer
    add_column :asana_ratings, :rating_14, :integer
    add_column :asana_ratings, :rating_15, :integer
    add_column :asana_ratings, :rating_16, :integer
    add_column :asana_ratings, :rating_17, :integer
    add_column :asana_ratings, :rating_18, :integer
    add_column :asana_ratings, :rating_19, :integer
    add_column :asana_ratings, :rating_20, :integer
  end
end
