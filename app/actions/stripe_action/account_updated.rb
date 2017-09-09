class StripeAction::AccountUpdated < StripeAction::Base

  def call(stripe_event)
    Rails.logger.info "Inside AccountUpdated #{stripe_event.inspect}"
    stripe_account = stripe_event.data.object
    provider = Provider.find_by(stripe_account_id: stripe_account.id)
    
    if provider.present?
      provider.update_attributes(charges_enabled: stripe_account.charges_enabled, 
                                 payouts_enabled: stripe_account.payouts_enabled,
                                 verification_status: stripe_account.legal_entity.verification.status,
                                 stripe_file_id: stripe_account.legal_entity.verification.document
                                )
      return provider
    end
  end

end