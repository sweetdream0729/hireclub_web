class BankAccount < ApplicationRecord
  belongs_to :provider

  validates :provider, presence: true
  validates :stripe_bank_account_id, presence: true
  validates :bank_name, presence: true
  validates :routing_number, presence: true
  validates :fingerprint, presence: true

  def self.create_bank_account(token, provider)
  	account = Stripe::Account.retrieve(provider.stripe_account_id)
	external_account = account.external_accounts.create(external_account: token)
    bank_account = provider.bank_accounts.build({
    	stripe_bank_account_id: external_account["id"],
    	holder_name: external_account["account_holder_name"],
    	bank_name: external_account["bank_name"],
    	routing_number: external_account["routing_number"],
    	fingerprint: external_account["fingerprint"],
    	country: external_account["country"]
    })
    bank_account.save
    return bank_account
  end

  
end
