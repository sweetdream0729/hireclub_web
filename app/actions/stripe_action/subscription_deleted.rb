class StripeAction::SubscriptionDeleted < StripeAction::Base

  def call(stripe_event)
    stripe_subscription = stripe_event.data.object

    subscription = Subscription.where(stripe_subscription_id: stripe_subscription.id).first
    
    if subscription && stripe_subscription.status == Subscription::CANCELED
      subscription.cancel
    end
    
    subscription
  end

end