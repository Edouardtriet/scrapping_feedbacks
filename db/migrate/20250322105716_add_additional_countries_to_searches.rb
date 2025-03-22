class AddAdditionalCountriesToSearches < ActiveRecord::Migration[7.1]
  def change
    add_column :searches, :additional_countries, :string
  end
end
