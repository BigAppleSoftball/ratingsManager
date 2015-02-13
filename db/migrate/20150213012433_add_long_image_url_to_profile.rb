class AddLongImageUrlToProfile < ActiveRecord::Migration
  def up
    add_column :profiles, :long_image_url, :string
  end

  def down
    remove_column :profiles, :long_image_url
  end
end
