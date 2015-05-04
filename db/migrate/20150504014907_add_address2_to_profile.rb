class AddAddress2ToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :address2, :string
  end
end
