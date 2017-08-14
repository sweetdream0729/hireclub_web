class Provider::CreateProvider

  attr_accessor :user
  attr_accessor :country

  def initialize(user, params, ip)  
    @user    = user
    @params = params
    @ip = ip
  end

  def call
    provider = Provider.create_account(@user, @params, @ip)
  end

end