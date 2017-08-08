class StripeAction::CardCreated < StripeAction::Base

  def call(stripe_event)
    Rails.logger.info "CardCreated #{stripe_event.inspect}"
    stripe_card = stripe_event.data.object
    user = User.find_by(stripe_customer_id: stripe_card.customer)
    if user.present?
      card = Card.create_or_update_card_from_stripe_card(user, stripe_card)
      return card
    end
  end

end