class AddFieldsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :emergency_contact_name, :string
    add_column :profiles, :emergency_contact_relationship, :string
    add_column :profiles, :emergency_contact_phone, :string
    add_column :rosters, :is_non_player, :boolean
  end
end
