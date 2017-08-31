class EventRetriever
  def call(params)

    # Events that occur in connected accounts contain a `account` parameter.  
    if params[:account].present?
      account = Provider.find_by!(stripe_account_id: params[:account])
      return nil if account.empty? || account.client_secret_key.nil?
      event = Stripe::Event.retrieve(params[:id], account.client_secret_key)
  	else
  	  event = Stripe::Event.retrieve(params[:id])
    end

    event
  end
end

StripeEvent.event_retriever = EventRetriever.new
StripeEvent.configure do |events|
  events.all BillingEventLogger.new(Rails.logger)
  events.subscribe 'customer.subscription.created', StripeAction::SubscriptionCreated.new
  events.subscribe 'customer.subscription.deleted', StripeAction::SubscriptionDeleted.new
  events.subscribe 'charge.succeeded', StripeAction::ChargeSucceeded.new
  events.subscribe 'customer.source.created', StripeAction::CardCreated.new
  events.subscribe 'customer.source.updated', StripeAction::CardCreated.new
  events.subscribe 'account.updated', StripeAction::AccountUpdated.new
  events.subscribe 'account.external_account.created', StripeAction::BankAccountCreated.new
end
