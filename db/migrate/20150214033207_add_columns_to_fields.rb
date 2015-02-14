class AddColumnsToFields < ActiveRecord::Migration
  def up
    add_column :fields, :address, :string
    add_column :fields, :city, :string
    add_column :fields, :zip,  :string
    add_column :fields, :by_car, :text
    add_column :fields, :by_bus, :text
    add_column :fields, :by_train, :text
    add_column :fields, :parking, :text
    add_column :fields, :is_active, :boolean
  end

  def down
    remove_column :fields, :address
    remove_column :fields, :city
    remove_column :fields, :zip
    remove_column :fields, :by_car
    remove_column :fields, :by_bus
    remove_column :fields, :by_train
    remove_column :fields, :parking 
    remove_column :fields, :is_active
  end
end
