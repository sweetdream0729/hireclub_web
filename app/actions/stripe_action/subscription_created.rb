class StripeAction::SubscriptionCreated < StripeAction::Base

  def call(stripe_event)
    Rails.logger.info "SubscriptionCreated #{stripe_event.inspect}"
    
    stripe_subscription = stripe_event.data.object

    user = User.find_by(stripe_customer_id: stripe_subscription.customer)
    if user
      subscription = user.subscriptions.where(stripe_subscription_id: stripe_subscription.id).first_or_initialize
      
      subscription.update(
        price_cents:      stripe_subscription.plan.amount,
        stripe_plan_name: stripe_subscription.plan.name,
        stripe_plan_id:   stripe_subscription.plan.id
      )

      subscription.update_status(stripe_subscription.status)
      return subscription
    end
  end

end