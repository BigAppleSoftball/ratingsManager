class AddImageUrlToHof < ActiveRecord::Migration
  def up
    add_column :hallof_famers, :image_url, :string
  end

  def down
    remove_column :hallof_famers, :image_url
  end
end
