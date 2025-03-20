class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :title
      t.integer :rating
      t.text :response
      t.string :store_type
      t.datetime :posted_at
      t.references :search, null: false, foreign_key: true

      t.timestamps
    end
  end
end
