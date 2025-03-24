class UpdateSearchesTable < ActiveRecord::Migration[7.1]
  def change
    remove_reference :searches, :country, foreign_key: true
    add_column :searches, :country, :string
  end
end
