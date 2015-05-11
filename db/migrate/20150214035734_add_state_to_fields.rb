class AddStateToFields < ActiveRecord::Migration
  def up
    add_column :fields, :state, :string
  end

  def down
     remove_column :fields, :state
  end
end
