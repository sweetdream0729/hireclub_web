class Card < ApplicationRecord
  scope :active,      -> { where(active: true) }
  scope :not_deleted, -> { where(deleted_on_stripe: false) }
  scope :chargeable,  -> { active.not_deleted }
  scope :default,     -> { where(is_default: true) }
  scope :by_recent,   -> { order(created_at: :desc) }

  # Assocations
  belongs_to :user

  # Extensions
  auto_strip_attributes :stripe_card_id, :squish => true
  auto_strip_attributes :stripe_customer_id, :squish => true
  auto_strip_attributes :fingerprint, :squish => true

  # Validations
  validates :user, presence: true
  validates :stripe_customer_id, presence: true
  validates :brand, presence: true
  validates :last4, presence: true

  validates :stripe_card_id, presence: true, :uniqueness => {:scope => :user_id}
  validates :fingerprint, :uniqueness => {:scope => :user_id}

  before_destroy :remove_from_stripe

  def remove_from_stripe
    # destroy card on stripe
    begin
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      begin
        customer.sources.retrieve(stripe_card_id).delete() if customer
        self.update_attribute(:deleted_on_stripe, true)
      rescue Stripe::InvalidRequestError
      end
    rescue Stripe::InvalidRequestError
      self.update_attribute(:deleted_on_stripe, true)
    end
    
    self.update_attributes(active: false, default: false)

    return true
  end
end
