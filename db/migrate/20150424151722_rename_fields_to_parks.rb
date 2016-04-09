class RenameFieldsToParks < ActiveRecord::Migration
  def change
    rename_table :fields, :parks
  end 
end
