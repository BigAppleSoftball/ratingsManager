class DefaultIsCoedToNull < ActiveRecord::Migration
  def self.up
    change_column :divisions, :is_coed, :boolean, :default => false
  end

  def self.down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
