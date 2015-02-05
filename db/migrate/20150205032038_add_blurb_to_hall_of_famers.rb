class AddBlurbToHallOfFamers < ActiveRecord::Migration
  def up
    add_column :hallof_famers, :details, :text
  end
 
  def down
    remove_column :hallof_famers, :details
  end
end
