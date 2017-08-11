class Provider::CreateProvider

  attr_accessor :user
  attr_accessor :country

  def initialize(user, country, ip)  
    @user    = user
    @country = country
    @ip = ip
  end

  def call
    provider = Provider.create_account(@user, @country, @ip)
  end

end