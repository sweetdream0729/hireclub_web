class StripeAction::Base
  def self.get_event(stripe_event_id)
    stripe_event = Stripe::Event.retrieve(stripe_event_id)
  end
end