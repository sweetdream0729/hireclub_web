class AppointmentReview < ApplicationRecord
  # Extentions
  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true
  
  auto_strip_attributes :text, :squish => true
  nilify_blanks

  # Associations
  belongs_to :appointment
  belongs_to :user

  # Validations
  validates :user, presence: true
  validates :appointment, presence: true
  validates_uniqueness_of :appointment_id, message: 'can have only one review'
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validate :appointment_should_be_complete

  def appointment_should_be_complete
    if appointment.present? && !appointment.completed?
      errors.add(:appointment, "Appointment should be completed")
    end
  end
end

