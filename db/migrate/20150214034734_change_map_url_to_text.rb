class ChangeMapUrlToText < ActiveRecord::Migration
  def up
    change_column :fields, :google_map_url, :text
  end

  def down
    change_column :fields, :google_map_url, :string
  end
end
