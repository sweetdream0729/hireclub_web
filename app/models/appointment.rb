class Appointment < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :acuity_id

  # Associations
  belongs_to :user
  belongs_to :appointment_type
  has_many :appointment_messages, dependent: :destroy
  has_many :participants, through: :appointment_messages, source: :user


  def name
    appointment_type.try(:name)
  end
  
end
