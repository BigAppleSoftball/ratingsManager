class AddIsPickupPlayerToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :is_pickup_player, :boolean
  end
end
