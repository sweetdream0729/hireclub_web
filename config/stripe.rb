StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.created', StripeAction::SubscriptionCreated.new
  events.subscribe 'charge.succeeded', StripeAction::ChargeSucceeded.new
  events.subscribe 'customer.source.created', StripeAction::CardCreated.new
  events.subscribe 'customer.source.updated', StripeAction::CardCreated.new
end
