class Provider::UpdateProvider

  attr_accessor :stripe_account_id

  def initialize(id)  
    @stripe_account_id = id
  end

  def call
    #update the verifications details
    provider = Provider.find_by(stripe_account_id: @stripe_account_id)
    account = Stripe::Account.retrieve(@stripe_account_id)

    account.legal_entity.type = "individual"
    account.legal_entity.first_name = provider.first_name
    account.legal_entity.last_name = provider.last_name
    
    account.tos_acceptance.date = provider.tos_acceptance_date.to_i
    account.tos_acceptance.ip = provider.tos_acceptance_ip

    account.legal_entity.dob.day = provider.date_of_birth.strftime("%d")
    account.legal_entity.dob.month = provider.date_of_birth.strftime("%m")
    account.legal_entity.dob.year = provider.date_of_birth.strftime("%Y")

    account.legal_entity.address.city = provider.city
    account.legal_entity.address.country = provider.country
    account.legal_entity.address.line1 = provider.address_line_1
    account.legal_entity.address.line2 = provider.address_line_2
    account.legal_entity.address.state = provider.state
    account.legal_entity.address.postal_code = provider.postal_code
    
    account.legal_entity.ssn_last_4 = provider.ssn.last(4)
    account.legal_entity.personal_id_number = provider.ssn

    #upload id proof for provider
    stripe_file = Stripe::FileUpload.create({
        :purpose => 'identity_document',
        :file => File.new(provider.id_proof.path)
      },
      {:stripe_account => provider.stripe_account_id}
    )
    provider.stripe_file_id = stripe_file["id"]
    provider.save
    account.legal_entity.verification.document = provider.stripe_file_id
    account.save
    account = Stripe::Account.retrieve(@stripe_account_id)
  end

end