class ChangeDivisionOrder < ActiveRecord::Migration
  class ChangeTeamDescription < ActiveRecord::Migration
  def up
    rename_column :division, :div_order, :display_order
  end

  def down
    rename_column :division, :display_order, :div_order
  end
end

end
