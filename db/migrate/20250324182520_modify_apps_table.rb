class ModifyAppsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :apps, :platform
    remove_column :apps, :icon_url
    remove_column :apps, :developer

    add_column :apps, :apple_id, :string
    add_column :apps, :google_id, :string
  end
end
