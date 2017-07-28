StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.created', StripeAction::SubscriptionCreated.new
end

Stripe.api_version = "2016-03-07"