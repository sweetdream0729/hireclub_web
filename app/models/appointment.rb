class Appointment < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :acuity_id

  # Associations
  belongs_to :user
  belongs_to :appointment_type
  has_many :appointment_messages, dependent: :destroy
  has_many :participants, through: :appointment_messages, source: :user


  # Validations
  validates :acuity_id, presence: true, uniqueness: true

  def name
    appointment_type.try(:name)
  end

  def canceled?
    canceled_at.present?
  end

  def active?
    !canceled?
  end

  def status
    return "Canceled" if canceled?
  end

  def cancel!
    if canceled_at.nil?
      self.canceled_at = DateTime.now
      self.save
    end
  end

  def reschedule!(new_start_time, new_end_time)
    self.start_time = new_start_time
    self.end_time = new_end_time
    self.save
  end
  
end
