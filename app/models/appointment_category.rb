class AppointmentCategory < ApplicationRecord
  # Extensions
  include Searchable
  extend FriendlyId
  friendly_id :name, use: :slugged
  dragonfly_accessor :image
  auto_strip_attributes :name, :squish => true

  # Associations
  has_many :appointment_types

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}


end
