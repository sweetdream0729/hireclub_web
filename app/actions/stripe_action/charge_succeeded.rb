class StripeAction::ChargeSucceeded < StripeAction::Base

  def call(stripe_event)
    Rails.logger.info "ChargeSucceeded #{stripe_event.inspect}"
    
    stripe_charge = Stripe::Charge.retrieve({ id: stripe_event.data.object.id, expand: ['balance_transaction'] })
    payment = Payment.create_from_stripe_charge(stripe_charge)
    return payment
  end

end