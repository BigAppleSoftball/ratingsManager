class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :profile_id
      t.text :rating_notes
      t.text :approver_notes
      t.string :rating_list
      t.integer :rating_total
      t.datetime :date_rated
      t.datetime :date_approved
      t.integer :rated_by_profile_id
      t.integer :approved_by_profile_id
      t.boolean :is_provisional
      t.boolean :is_approved
      t.boolean :is_active
      t.text :history
      t.text :updated
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
      t.integer :rating_13
      t.integer :rating_14
      t.integer :rating_15
      t.integer :rating_16
      t.integer :rating_17
      t.integer :rating_18
      t.integer :rating_19
      t.integer :rating_20
      t.integer :rating_21
      t.integer :rating_22
      t.integer :rating_23
      t.integer :rating_24
      t.integer :rating_25
      t.integer :rating_26
      t.integer :rating_27
      t.datetime :ssma_timestamp
      t.integer :ng
      t.integer :nr

      t.timestamps
    end
  end
end
