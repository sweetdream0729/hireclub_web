class StripeAction::ChargeSucceeded < StripeAction::Base

  def call(stripe_event)
    Rails.logger.info stripe_event
    stripe_charge = Stripe::Charge.retrieve({ id: stripe_event.data.object.id, expand: ['balance_transaction'] })
    payment = Payment.create_from_stripe_charge(stripe_charge)
    return payment
  end

end