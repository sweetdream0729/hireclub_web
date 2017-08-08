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

  def self.create_or_update_card_from_stripe_card(user, stripe_card)
    # check even soft deleted cards for fingerprint
    card = user.cards.where(fingerprint: stripe_card[:fingerprint]).first_or_initialize

    card.user = user
    card.stripe_card_id = stripe_card[:id]
    card.stripe_customer_id = stripe_card[:customer]
    card.brand = stripe_card.brand
    card.last4 = stripe_card.last4
    card.funding = stripe_card.funding
    card.exp_month = stripe_card.exp_month
    card.exp_year = stripe_card.exp_year
    card.country = stripe_card.country
    card.cvc_check = stripe_card.cvc_check
    card.name = stripe_card.name
    card.deleted_on_stripe = false
    card.save
    
    puts card.inspect
    puts stripe_card.inspect

    return card
  end
end
