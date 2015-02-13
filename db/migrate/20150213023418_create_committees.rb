class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.string :email
      t.integer :profile_id
      t.string :name

      t.timestamps
    end
  end
end
