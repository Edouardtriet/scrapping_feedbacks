# app/models/search.rb
class Search < ApplicationRecord
  belongs_to :user

  # Step validations
  serialize :additional_countries, JSON
  validates :app_name, presence: true, if: -> { current_step == :app_name }
  validates :store_type, presence: true, if: -> { current_step == :store_type }
  validates :country, presence: true, if: -> { current_step == :country }

  # Store type specific validations
  validate :validate_store_ids, if: -> { current_step == :store_type }

  attr_accessor :current_step
  attr_accessor :select_all

  def validate_store_ids
    if store_type == 'apple' && apple_id.blank?
      errors.add(:apple_id, "must be provided for Apple App Store")
    elsif store_type == 'google' && google_id.blank?
      errors.add(:google_id, "must be provided for Google Play Store")
    elsif store_type == 'both' && (apple_id.blank? || google_id.blank?)
      errors.add(:base, "Both Apple and Google store IDs are required")
    end
  end
end
