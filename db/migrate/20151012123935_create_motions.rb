class CreateMotions < ActiveRecord::Migration
  def change
    create_table :motions do |t|
      t.string :title
      t.text :description
      t.boolean :is_active
      t.boolean :is_anonymous

      t.timestamps
    end
  end
end
