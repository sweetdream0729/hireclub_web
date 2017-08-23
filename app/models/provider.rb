class Provider < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  # Constants
  COUNTRIES = [
    { name: 'United States', code: 'US' }
  ]

  # Associations
  belongs_to :user
  has_many :bank_accounts

  # Validations
  validates :user, presence:true
  validates :stripe_account_id, presence: true
  validates :tos_acceptance_ip, presence: true
  validates :tos_acceptance_date, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :ssn, presence: true, uniqueness: { case_sensitive: false }
  validates :date_of_birth, presence: true
  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :postal_code, presence: true

  phony_normalize :phone, :default_country_code => 'US', :add_plus => false
  validates_plausible_phone :phone, country_code: 'US'
  validates_uniqueness_of :phone, allow_blank: true, message: '%{value} has already been taken'
  validates :phone, uniqueness: true, presence: true

  before_destroy :remove_from_stripe

  def remove_from_stripe
    # destroy account on stripe
    begin
      account = Stripe::Account.retrieve(stripe_account_id)
      begin
        account.delete
      rescue Stripe::InvalidRequestError
      end
    rescue Stripe::InvalidRequestError
      Rails.logger.warn "Can't delete provider #{id}. Stripe Account ID #{stripe_account_id} not found."
    end
    
    return true
  end

  #for creating stripe account
  def self.create_account(user, params, ip)
  	if !user.is_provider?
  		options = {
  			type: 'custom',
		    country: params[:country],
		    email: user.email
  		}
	  	account = Stripe::Account.create(options)
		provider = Provider.new(params)
		provider.user_id = user.id
		provider.stripe_account_id = account["id"]
		provider.charges_enabled = account["charges_enabled"]
		provider.payouts_enabled = account["payouts_enabled"]
		provider.tos_acceptance_ip = ip
		provider.tos_acceptance_date = DateTime.now
    provider.client_secret_key = account["keys"]["secret"]
    provider.client_publishable_key = account["keys"]["publishable"]
		#update stripe account details if all details
		if provider.save
			ProviderRelayJob.perform_later(account["id"], "update")
		else
		#delete the account if verifcation detail not provided
			ProviderRelayJob.perform_later(account["id"], "delete")
		end														
	end
	 return provider
  end

end
