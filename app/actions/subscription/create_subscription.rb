class Subscription::CreateSubscription

  attr_accessor :user
  attr_accessor :subscription
  attr_accessor :request

  def initialize(user, card_token, params, request=nil)  
    @user       = user
    @card_token = card_token
    @params     = params
    @request    = request
    
   # subscribe(SubscriptionListener.new)
  end

  def call
    subscription = Subscription.start(@user, @card_token, @params)

    return subscription
  end

end