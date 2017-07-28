class Subscription::CancelSubscription
  include Wisper::Publisher

  attr_accessor :user
  attr_accessor :subscription
  attr_accessor :request
  attr_accessor :reason

  def initialize(user, subscription, request=nil, reason=nil)  
    @user         = user
    @subscription = subscription
    @request      = request
    @reason       = reason
    
    subscribe(SubscriptionListener.new)
  end

  def call
    subscription.cancel(reason) if subscription.cancelable?

    if subscription.is_canceled?
      broadcast(:on_cancel_subscription, subscription, request)
    else
      broadcast(:on_cancel_subscription_failure, subscription, request)
    end

    return subscription
  end

end