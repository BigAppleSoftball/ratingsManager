class AddTeamsnapIdToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :teamsnap_id, :integer
  end
end
