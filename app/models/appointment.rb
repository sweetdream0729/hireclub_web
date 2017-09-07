class Appointment < ApplicationRecord
  # Constants
  COMMISSION = 0.7
  
  # Extensions
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  include PgSearch
  pg_search_scope :text_search,
                  :against => [:first_name, :last_name],
                  :associated_against => {
                    :user => {:name => "A", :username => "A"},
                    :appointment_type => {:name => "B"},
                    :appointment_category => {:name => "C"},
                    :assigned_users => {:name => "D", :username => "D"}
                  }

  extend FriendlyId
  friendly_id :acuity_id
  paginates_per 10

  monetize :price_cents
  monetize :amount_paid_cents
  monetize :payout_price_cents

  # Scopes
  scope :active,        -> { where(canceled_at: nil) }
  scope :incomplete,    -> { where(completed_on: nil) }
  scope :unassigned,    -> { where(assignees_count: 0) }
  scope :canceled,      -> { where("appointments.canceled_at IS NOT NULL") }
  scope :completed,     -> { where("appointments.completed_on IS NOT NULL") }
  scope :upcoming,      -> { where('appointments.start_time > ?', Time.current) }
  scope :by_start_time, -> { order('appointments.start_time', 'appointments.id') }

  # Associations
  belongs_to :user
  belongs_to :appointment_type
  belongs_to :completed_by, class_name: 'User'
  belongs_to :payee, class_name: 'User'
  has_many :appointment_messages, dependent: :destroy
  has_many :participants, through: :appointment_messages, source: :user
  has_many :assignees, dependent: :destroy
  has_many :assigned_users, through: :assignees, source: :user
  has_one :appointment_review, dependent: :destroy
  #added to support search by appointment_category
  has_one :appointment_category, through: :appointment_type 
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :payments, as: :payable, dependent: :destroy
  has_many :payouts, as: :payoutable, dependent: :destroy

  # Validations
  validates :acuity_id, presence: true, uniqueness: true
  
  #callbacks
  after_create :retrieve_payments

  def name
    appointment_type.try(:name)
  end
  
  def user_name
    return user.display_name if user.present?
    return "#{first_name} #{last_name}"
  end
    
  def category_name
    appointment_type.try(:appointment_category).try(:name)
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
      if self.save
        self.create_activity(key: AppointmentCancelActivity::KEY,
                           owner: user,
                           private: true)
      end
    end
  end

  def reschedule!(new_start_time, new_end_time)
    parameters = {old_start_time: self.start_time,
                  old_end_time: self.end_time}
    self.start_time = new_start_time
    self.end_time = new_end_time
    if self.save
      parameters.merge!({new_start_time: self.start_time,
                        new_end_time: self.end_time})
      self.create_activity(key: AppointmentRescheduleActivity::KEY,
                           owner: user,
                           private: true,
                           parameters: parameters)
    end
  end

  def reschedulable?
    !completed? && !canceled?
  end

  def complete!(completer)
    return false if completed_on.present?
    self.completed_by = completer
    self.completed_on = DateTime.now
    self.save

    self.create_activity_once :complete, owner: completer, recipient: user, private: true
    return true
  end

  def completed?
    completed_on.present?
  end

  def completable?
    !completed?
  end

  def refresh
    json = AcuityService.get_appointment(acuity_id)
    AcuityService.create_appointment(json)
    self.update_payments
    self.reload
  end

  def duration
    TimeDifference.between(start_time, end_time).in_minutes
  end

  def reviewed?
    appointment_review.present?
  end

  def retrieve_payments
    CreatePaymentJob.perform_later(self)
  end

  def update_payments
    Rails.logger.info "update_payments"
    payments_json = AcuityService.get_payments(self.acuity_id)
    Rails.logger.info puts payments_json.inspect

    payments_json.each do |payment_json|
      Rails.logger.info puts payment_json.inspect

      next if payment_json["amount"].blank?

      payment = self.payments.where(  external_id: payment_json["transactionID"], 
                                      processor:   payment_json["processor"]).first_or_initialize
      payment.amount_dollars = payment_json["amount"]
      payment.paid_on        = Chronic.parse(payment_json["created"])
      payment.user = self.user
      payment.save
      
    end
  end

  def payout!
    charge = self.payments.first
    provider = self.payee.provider
    if charge.present? && provider.present?
      payout = self.payouts.where(provider: provider,
                                  stripe_charge_id: charge.external_id,
                                  amount_cents: payout_price_cents).first_or_create
    end

    if payout.present?
      payout.transfer!
    end

    return payout
  end

  def paid_out!
    self.paid_out = true
    self.save
  end

  def payout_price_cents
    COMMISSION * price_cents
  end

  def users
    participants + assigned_users + [user]
  end
  
end
