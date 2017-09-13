class Provider::DeleteProvider

  attr_accessor :stripe_account_id

  def initialize(id)  
    @stripe_account_id = id
  end

  def call
    #delete the account 
    Provider.remove_from_stripe(@stripe_account_id)
  end

end