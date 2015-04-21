class TeamsnapPayments < ActiveRecord::Migration
  def change
    create_table :teamsnap_payments do |t|
      t.integer :teamsnap_player_id
      t.timestamps
    end

    create_table :teamsnap_payments_syncs do |t|
      t.string :run_by
      t.boolean :is_success
      t.timestamps
    end
  end
end
