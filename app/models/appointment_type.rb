class AppointmentType < ApplicationRecord
  # Extensions
  auto_strip_attributes :name, :squish => true
  monetize :price_cents
  dragonfly_accessor :image

  # Scopes
  scope :by_priority,    -> { order(priority: :asc) }

  # Associations
  belongs_to :appointment_category

  # Validations
  validates :name, presence: true
  validates :acuity_id, presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 0 }

  
  def acuity_link
    Rails.application.secrets.acuity_link + "/schedule.php?appointmentType=#{acuity_id}"
  end  
end
