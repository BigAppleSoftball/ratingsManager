class AddDefaultToAsanaRatings < ActiveRecord::Migration
  def change
    change_column :asana_ratings, :rating_1, :integer, :default => 0
    change_column :asana_ratings, :rating_2, :integer, :default => 0
    change_column :asana_ratings, :rating_3, :integer, :default => 0
    change_column :asana_ratings, :rating_4, :integer, :default => 0
    change_column :asana_ratings, :rating_5, :integer, :default => 0
    change_column :asana_ratings, :rating_6, :integer, :default => 0
    change_column :asana_ratings, :rating_7, :integer, :default => 0
    change_column :asana_ratings, :rating_8, :integer, :default => 0
    change_column :asana_ratings, :rating_9, :integer, :default => 0
    change_column :asana_ratings, :rating_10, :integer, :default => 0
    change_column :asana_ratings, :rating_11, :integer, :default => 0
    change_column :asana_ratings, :rating_12, :integer, :default => 0
    change_column :asana_ratings, :rating_13, :integer, :default => 0
    change_column :asana_ratings, :rating_14, :integer, :default => 0
    change_column :asana_ratings, :rating_15, :integer, :default => 0
    change_column :asana_ratings, :rating_16, :integer, :default => 0
    change_column :asana_ratings, :rating_17, :integer, :default => 0
    change_column :asana_ratings, :rating_18, :integer, :default => 0
    change_column :asana_ratings, :rating_19, :integer, :default => 0
    change_column :asana_ratings, :rating_20, :integer, :default => 0
  end
end
