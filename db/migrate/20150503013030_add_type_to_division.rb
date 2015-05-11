class AddTypeToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :type, :integer
  end
end
