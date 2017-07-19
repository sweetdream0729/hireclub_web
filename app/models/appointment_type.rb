class AppointmentType < ApplicationRecord
  # Extensions
  auto_strip_attributes :name, :squish => true

  # Associations
  belongs_to :appointment_category

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :acuity_id, presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.refresh_appointment_types
    acuity_options = AcuityService.appointment_types
    appointment_types = []

    acuity_options.each do |acuity_option|
      appointment_category = AppointmentCategory.where(name: acuity_option["category"]).first_or_create
      appointment_type_options = { name: acuity_option["name"], 
      							   description: acuity_option["description"], 
      							   duration: acuity_option["duration"], 
      							   price_cents: acuity_option["price"], 
      							   appointment_category_id: appointment_category.id }
      appointment_type = self.where(acuity_id: acuity_option["id"]).first_or_create(appointment_type_options)
      appointment_types << appointment_type
    end
    return appointment_types
  end
end
