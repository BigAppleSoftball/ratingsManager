class AddLastLoggedInToUsers < ActiveRecord::Migration
  def change
    add_column :profiles, :last_log_in, :datetime
  end
end
