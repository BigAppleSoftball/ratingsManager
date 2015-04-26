class AddLoginToProfile < ActiveRecord::Migration
  def up
    add_column :profiles, :password_digest, :string
    add_column :profiles, :remember_token, :string
  end
  def down
    remove_column :profiles, :password_digest
    remove_column :profiles, :remember_token
  end
end
