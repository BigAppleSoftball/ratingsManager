class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.integer :status
      t.string :name
      t.text :directions
      t.string :url
      t.string :google_map_url

      t.timestamps
    end
  end
end
