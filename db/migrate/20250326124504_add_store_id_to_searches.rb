class AddStoreIdToSearches < ActiveRecord::Migration[7.1]
  def change
    add_column :searches, :google_id, :string
    add_column :searches, :apple_id, :string
  end
end
