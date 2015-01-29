class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.integer :sponsor_id
      t.string :name
      t.string :url
      t.string :email
      t.string :phone
      t.string :details
      t.datetime :date_created
      t.datetime :date_updated
      t.integer :created_user_id
      t.integer :updated_user_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
