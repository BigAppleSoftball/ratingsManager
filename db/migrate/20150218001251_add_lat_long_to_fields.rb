class AddLatLongToFields < ActiveRecord::Migration
  def up
    add_column :fields, :lat, :float
    add_column :fields, :long, :float
  end

  def down
    remove_column :fields, :lat
    remove_column :fields, :long
  end
end
