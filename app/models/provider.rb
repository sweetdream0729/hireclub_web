class Provider < ApplicationRecord

  COUNTRIES = [
    { name: 'United States', code: 'US' },
    { name: 'Canada', code: 'CA' }
  ]
  belongs_to :user
  has_many :bank_accounts

  #validations
  validates :user, presence:true
  validates :stripe_account_id, presence: true
  validates :tos_acceptance_ip, presence: true
  validates :tos_acceptance_date, presence: true
  validates :first_name , presence: true
  validates :last_name , presence: true
  validates :phone , presence: true
  validates :ssn_last_4 , presence: true
  validates :date_of_birth , presence: true
  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :postal_code, presence: true

  #for creating stripe account
  def self.create_account(user, params, ip)
  	if !user.is_provider?
  		options = {
  			:type => 'custom',
		    :country => params[:country],
		    :email => user.email
  		}
	  	account = Stripe::Account.create(
			  
			)
			provider = Provider.new(params)
			provider.user_id = user.id
			provider.stripe_account_id = account["id"]
			provider.charges_enabled = account["charges_enabled"]
			provider.payouts_enabled = account["payouts_enabled"]
			provider.tos_acceptance_ip = ip
			provider.tos_acceptance_date = DateTime.now
			provider.save														
		end
		return provider
  end

end
