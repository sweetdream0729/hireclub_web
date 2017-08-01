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
  end

  def call
    subscription.cancel(reason) if subscription.cancelable?

    return subscription
  end

end