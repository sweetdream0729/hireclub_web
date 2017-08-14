class Provider::UpdateProvider

  attr_accessor :stripe_account_id

  def initialize(id)  
    @stripe_account_id = id
  end

  def call
    #update the verifications details
    provider = Provider.find_by(stripe_account_id: @stripe_account_id)
    account = Stripe::Account.retrieve(@stripe_account_id)
    Rails.logger.debug "\n\n\n\n #{account.inspect} \n\n\n\n"
    account.legal_entity.first_name = provider.first_name
    account.legal_entity.last_name = provider.last_name
    #Todo: check this again
    account.tos_acceptance.date = provider.tos_acceptance_date.to_i
    account.tos_acceptance.ip = provider.tos_acceptance_ip
    account.legal_entity.dob.day = provider.date_of_birth.strftime("%d")
    account.legal_entity.dob.month = provider.date_of_birth.strftime("%m")
    account.legal_entity.dob.year = provider.date_of_birth.strftime("%Y")
    
    account.save
  end

end