class AddNagaaaIdToProfile2 < ActiveRecord::Migration
  def change
    add_column :profiles, :nagaaa_id, :integer
  end
end
