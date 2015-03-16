class AddTeamsnapScans < ActiveRecord::Migration
  def change
    create_table :teamsnap_scan_accounts do |t|
      t.string :username
      t.string :password
      t.boolean :is_active
      t.timestamps
    end
  end
end
