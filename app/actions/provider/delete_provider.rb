class Provider::DeleteProvider

  attr_accessor :stripe_account_id

  def initialize(id)  
    @stripe_account_id = id
  end

  def call
    #delete the account
    account = Stripe::Account.retrieve(@stripe_account_id)
    account.delete
  end

end