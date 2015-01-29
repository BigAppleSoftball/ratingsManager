class ChangeSponsorDetailsToText < ActiveRecord::Migration
  def up
    change_column :sponsors, :details, :text
  end

  def down
    change_column :sponsors, :details, :string
  end
end
