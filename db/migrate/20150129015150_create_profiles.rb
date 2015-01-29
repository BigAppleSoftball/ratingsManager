class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :profile_code
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :nickname
      t.string :display_name
      t.integer :player_number
      t.string :gender
      t.string :shirt_size
      t.string :address
      t.string :state
      t.integer :zip
      t.string :phone
      t.string :emergency_name
      t.string :emergency_relation
      t.string :emergency_phone
      t.string :emergency_email
      t.string :position
      t.string :dob
      t.integer :team_id

      t.timestamps
    end
  end
end
