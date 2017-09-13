class Provider::UpdateProvider

  attr_accessor :stripe_account_id

  def initialize(id, provider)  
    @stripe_account_id = id
    @provider = provider
  end

  def call
    #update the verifications details
    begin
      account = Stripe::Account.retrieve(@stripe_account_id)

      account.legal_entity.type = "individual"
      account.legal_entity.first_name = @provider.first_name
      account.legal_entity.last_name = @provider.last_name
      
      account.tos_acceptance.date = @provider.tos_acceptance_date.to_i
      account.tos_acceptance.ip = @provider.tos_acceptance_ip

      account.legal_entity.dob.day = @provider.date_of_birth.strftime("%d")
      account.legal_entity.dob.month = @provider.date_of_birth.strftime("%m")
      account.legal_entity.dob.year = @provider.date_of_birth.strftime("%Y")

      account.legal_entity.address.city = @provider.city
      account.legal_entity.address.country = @provider.country
      account.legal_entity.address.line1 = @provider.address_line_1
      account.legal_entity.address.line2 = @provider.address_line_2
      account.legal_entity.address.state = @provider.state
      account.legal_entity.address.postal_code = @provider.postal_code
      
      account.legal_entity.ssn_last_4 = @provider.ssn.last(4)
      account.legal_entity.personal_id_number = @provider.ssn

      #upload id proof for provider
      if @provider.stripe_file_id.nil? && @provider.id_proof
        stripe_file = Stripe::FileUpload.create({
            :purpose => 'identity_document',
            :file => File.new(@provider.id_proof.path)
          },
          {:stripe_account => @provider.stripe_account_id}
        )
        
        account.legal_entity.verification.document = stripe_file["id"]
      end
      account.save
      account = Stripe::Account.retrieve(@stripe_account_id)
    rescue Stripe::InvalidRequestError
    end
  end

end