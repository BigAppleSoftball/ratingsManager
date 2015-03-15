class AddEmailToTeamsnapPayments < ActiveRecord::Migration
  def up
    add_column :teamsnap_payments, :teamsnap_player_email, :string
  end

  def down
    remove_column :teamsnap_payments, :teamsnap_player_email
  end
end
