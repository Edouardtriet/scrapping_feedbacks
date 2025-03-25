class Search < ApplicationRecord
  belongs_to :user
  has_many :reviews

  validates :app_name, :store_type, :country, presence: true
  validates :start_date, :end_date, presence: true

  def self.autocomplete_apps(query)
    App.where("LOWER(name) LIKE ?", "#{query.downcase}%")
       .limit(10)
       .pluck(:name)
  end
end
