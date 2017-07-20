class Appointment < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :acuity_id

  # Scopes
  scope :active,   -> { where(canceled_at: nil) }
  scope :canceled, -> { where("canceled_at IS NOT NULL") }
  scope :upcoming, -> { where('appointments.start_time > ?', Time.current) }

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

  def category_name
    appointment_type.appointment_category.name
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

  def refresh
    json = AcuityService.get_appointment(acuity_id)
    AcuityService.create_appointment(json)
    self.reload
  end
  
end
