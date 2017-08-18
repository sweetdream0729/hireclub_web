class StripeAction::BankAccountCreated < StripeAction::Base

  def call(stripe_event)
    Rails.logger.info "Inside BankAccountCreated #{stripe_event.inspect}"
    stripe_bank_account = stripe_event.data.object
    provider = Provider.find_by(stripe_account_id: stripe_bank_account.account)
    stripe_account = Stripe::Account.retrieve(provider.stripe_account_id)
    if provider.present?
      provider.update_attributes(charges_enabled: stripe_account.charges_enabled, payouts_enabled: stripe_account.payouts_enabled,verification_status: stripe_account.legal_entity.verification.status)
      return provider
    end
  end

end