class ChangeDivisionType < ActiveRecord::Migration
  def change
    rename_column :divisions, :type, :kind
  end
end
