class BankAccount < ApplicationRecord
  belongs_to :provider

  validates :provider, presence: true
  validates :stripe_bank_account_id, presence: true
  validates :bank_name, presence: true
  validates :routing_number, presence: true
  validates :fingerprint, presence: true

  
end
