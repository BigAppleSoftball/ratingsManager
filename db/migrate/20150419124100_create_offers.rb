class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :name
      t.text :description
      t.string :image
      t.string :link
      t.string :google_map_url
      t.string :company_name

      t.timestamps
    end
  end
end
