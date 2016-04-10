class CreateAsanaRatings < ActiveRecord::Migration
  def change
    create_table :asana_ratings do |t|
      t.integer :profile_id
      t.boolean :is_approved
      t.integer :approved_profile_id
      t.integer :rating_1
      t.integer :rating_2
      t.integer :rating_3
      t.integer :rating_4
      t.integer :rating_5
      t.integer :rating_6
      t.integer :rating_7
      t.integer :rating_8
      t.integer :rating_9
      t.integer :rating_10
      t.integer :rating_11
      t.integer :rating_12

      t.timestamps
    end
  end
end
