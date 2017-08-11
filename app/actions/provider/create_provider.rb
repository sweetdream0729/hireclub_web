class Provider::CreateProvider

  attr_accessor :user
  attr_accessor :country

  def initialize(user, country)  
    @user    = user
    @country = country
  end

  def call
    provider = Provider.create_account(@user, @country)
  end

end