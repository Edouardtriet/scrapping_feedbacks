class Search < ApplicationRecord
  belongs_to :user
  has_many :reviews

  validates :app_name, :store_type, :country, presence: true
  validates :start_date, :end_date, presence: true
end
