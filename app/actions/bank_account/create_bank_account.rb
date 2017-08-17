class BankAccount::CreateBankAccount

  attr_accessor :token
  attr_accessor :params 

  def initialize(token, provider)  
    @token = token
    @provider = provider
  end

  def call
    bank_account = BankAccount.create_bank_account(@token, @provider)
  end

end