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
  validates :appointment_id, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validate :appointment_completed
  validate :text_required_if_low_rating

  def appointment_completed
    if appointment.present? && !appointment.completed?
      errors.add(:appointment, "must be completed")
    end
  end

  def text_required_if_low_rating
    if appointment.present? && text.blank? && rating.present? && rating < 5
      errors.add(:text, "is required")
    end
  end
end

