class Payment < ApplicationRecord
  include Admin::PaymentAdmin
  # Extensions
  monetize :amount_cents
  monetize :processor_fee_cents

  # Scopes
  scope :by_oldest, -> {order(created_at: :asc)}

  # Associations
  belongs_to :payable, polymorphic: true
  belongs_to :user

  # Validations
  validates :payable, presence: true
  validates :processor, presence: true
  validates :external_id, presence: true
  validates :amount_cents, presence: true
  validates :paid_on, presence: true
  validates_uniqueness_of :external_id, scope: :processor


  def amount_dollars=(value)
    value = value.gsub("$","").gsub(".","")
    self.amount_cents = value
  end

  def self.create_from_stripe_charge(stripe_charge)
    payment = Payment.where(  external_id: stripe_charge.id, processor: "stripe").first_or_initialize
    payment.amount_cents = stripe_charge.amount
    payment.paid_on      = Time.at(stripe_charge.created).to_datetime
    payment.description  = stripe_charge.description
    payment.user = User.where(stripe_customer_id: stripe_charge.customer).first

    stripe_invoice = Stripe::Invoice.retrieve(stripe_charge.invoice)
    payment.payable = Subscription.where(stripe_subscription_id: stripe_invoice.subscription).first
    payment.save

    return payment
  end

  def stripe?
    processor == "stripe"
  end
end
