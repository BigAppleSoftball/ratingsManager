class CreateHallofFamers < ActiveRecord::Migration
  def change
    create_table :hallof_famers do |t|
      t.integer :profile_id
      t.datetime :date_inducted
      t.boolean :is_active
      t.boolean :is_inducted

      t.timestamps
    end
  end
end
