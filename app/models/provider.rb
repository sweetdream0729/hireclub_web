class Provider < ApplicationRecord
  # Extensions
  dragonfly_accessor :id_proof
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true
  nilify_blanks

  # Constants
  COUNTRIES = [
    { name: 'United States', code: 'US' }
  ]

  # Scopes
  scope :by_recent,       -> { order(created_at: :desc) }

  # Associations
  belongs_to :user
  delegate :name, to: :user
  has_many :bank_accounts, dependent: :destroy
  has_many :payouts, dependent: :destroy

  # Validations
  validates_size_of :id_proof, maximum: 10.megabytes

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
  validates :id_proof, presence: true, on: :create

  phony_normalize :phone, :default_country_code => 'US', :add_plus => false
  validates_plausible_phone :phone, country_code: 'US'
  validates_uniqueness_of :phone, allow_blank: true, message: '%{value} has already been taken'

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
      begin
  	   account = Stripe::Account.create(options)
      rescue Stripe::InvalidRequestError
      end
  		provider = Provider.new(params)
      provider.date_of_birth = Chronic.parse(params[:date_of_birth])
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
  			ProviderUpdateJob.perform_later(account["id"], provider)
  		else
  		#delete the account if verifcation detail not provided
  			ProviderDeleteJob.perform_later(account["id"])
  		end
  	end
	 return provider
  end

end
