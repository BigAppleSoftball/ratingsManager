class AddResetToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :reset_token, :string
    add_column :profiles, :reset_sent_at, :datetime
    add_column :profiles, :reset_digest, :string
  end
end
