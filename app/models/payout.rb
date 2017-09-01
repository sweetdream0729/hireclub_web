class Payout < ApplicationRecord
  belongs_to :provider
  belongs_to :payoutable, polymorphic: true


  # Validations
  validates :provider, presence: true
  validates :payoutable, presence: true
  validates :stripe_charge_id, presence: true
  validates :amount_cents, presence: true, numericality: { greater_than_or_equal_to: 1 }
end
