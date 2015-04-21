class AddPlayerNameToTeamsnapPayments < ActiveRecord::Migration
    def up
      add_column :teamsnap_payments, :teamsnap_player_name, :string
    end

  def down
    remove_column :teamsnap_payments, :teamsnap_player_name
  end
end
