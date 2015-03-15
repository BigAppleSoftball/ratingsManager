class AddCountsToSync < ActiveRecord::Migration
  def up
    add_column :teamsnap_payments_syncs, :total_paid_players, :integer
    add_column :teamsnap_payments_syncs, :total_unpaid_players, :integer
    add_column :teamsnap_payments_syncs, :total_players, :integer
  end

  def down
    remove_column :teamsnap_payments_syncs, :total_paid_players
    remove_column :teamsnap_payments_syncs, :total_unpaid_players
    remove_column :teamsnap_payments_syncs, :total_players
  end
end
