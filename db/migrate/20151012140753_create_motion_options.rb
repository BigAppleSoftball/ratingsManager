class CreateMotionOptions < ActiveRecord::Migration
  def change
    create_table :motion_options do |t|
      t.integer :issue_id
      t.string :title

      t.timestamps
    end
  end
end
