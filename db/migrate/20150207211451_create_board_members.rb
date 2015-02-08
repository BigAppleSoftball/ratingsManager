class CreateBoardMembers < ActiveRecord::Migration
  def change
    create_table :board_members do |t|
      t.string :email
      t.string :position
      t.integer :display_order
      t.string :first_name
      t.string :last_nale
      t.string :alt_email
      t.string :image_url

      t.timestamps
    end
  end
end
