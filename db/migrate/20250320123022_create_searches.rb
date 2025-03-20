class CreateSearches < ActiveRecord::Migration[7.1]
  def change
    create_table :searches do |t|
      t.references :user, null: false, foreign_key: true
      t.string :store_type
      t.references :country, null: false, foreign_key: true
      t.string :app_name

      t.timestamps
    end
  end
end
