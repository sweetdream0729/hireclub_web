class StripeAction::AccountUpdated < StripeAction::Base

  def call(stripe_event)
    Rails.logger.info "Inside AccountUpdated #{stripe_event.inspect}"
    stripe_account = stripe_event.data.object
    provider = Provider.find_by(stripe_account_id: stripe_account.id)
    
    if provider.present?
      provider.update_attributes(charges_enabled: stripe_account.charges_enabled, payouts_enabled: stripe_account.payouts_enabled,verification_status: stripe_account.legal_entity.verification.status)
      Rails.logger.info "AccountUpdated #{provider.inspect}"
      ProviderRelayJob.perform_later(provider.stripe_account_id, "update")
      return provider
    end
  end

end