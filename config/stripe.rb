StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.created', StripeAction::SubscriptionCreated.new
  events.subscribe 'charge.succeeded', StripeAction::ChargeSucceeded.new
end


Stripe.api_version = "2016-03-07"