class AddColumnToSearches < ActiveRecord::Migration[7.1]
  def change
    add_column :searches, :countries, :string
    add_column :searches, :start_date, :date
    add_column :searches, :end_date, :date
  end
end
