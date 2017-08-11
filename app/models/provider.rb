class Provider < ApplicationRecord
  belongs_to :user

  #validations
  validates :user, presence:true
  validates :stripe_account_id, presence: true

  #for creating stripe account
  def self.create_account(user, country)
  	if !user.is_provider?
	  	account = Stripe::Account.create(
			  :type => 'custom',
			  :country => country,
			  :email => user.email
			)
			provider = Provider.new(user_id: user.id)
			provider.stripe_account_id = account["id"]
			provider.charges_enabled = account["charges_enabled"]
			provider.payouts_enabled = account["payouts_enabled"]
			provider.save														
		end
		return provider
  end

end
