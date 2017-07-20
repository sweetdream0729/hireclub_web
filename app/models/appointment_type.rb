class AppointmentType < ApplicationRecord
  # Extensions
  auto_strip_attributes :name, :squish => true

  # Associations
  belongs_to :appointment_category
  has_many :appointment_type_providers, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :acuity_id, presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 0 }

  
end
