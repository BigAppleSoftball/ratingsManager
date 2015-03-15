class AddPlayersUpdatedCountToTeamsnapPayments < ActiveRecord::Migration
  def up
    add_column :teamsnap_payments_syncs, :total_players_updated, :integer
  end

  def down
    remove_column :teamsnap_payments_syncs, :total_players_updated
  end
end
