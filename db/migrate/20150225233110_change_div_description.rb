class ChangeDivDescription < ActiveRecord::Migration
  def up
    rename_column :divisions, :div_description, :description
  end

  def down
    rename_column :divisions, :description, :div_description
  end
end
