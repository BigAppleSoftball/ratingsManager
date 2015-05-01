class AddTeamsnapIdToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :teamsnap_id, :integer
  end
end
