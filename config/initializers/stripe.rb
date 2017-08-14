StripeEvent.configure do |events|
  events.all BillingEventLogger.new(Rails.logger)
  events.subscribe 'customer.subscription.created', StripeAction::SubscriptionCreated.new
  events.subscribe 'customer.subscription.deleted', StripeAction::SubscriptionDeleted.new
  events.subscribe 'charge.succeeded', StripeAction::ChargeSucceeded.new
  events.subscribe 'customer.source.created', StripeAction::CardCreated.new
  events.subscribe 'customer.source.updated', StripeAction::CardCreated.new
end
