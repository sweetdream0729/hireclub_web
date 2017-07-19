class Appointment < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :acuity_id

  # Associations
  belongs_to :user
  belongs_to :appointment_type

  
end
