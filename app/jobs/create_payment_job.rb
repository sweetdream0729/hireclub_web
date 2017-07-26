class CreatePaymentJob < ApplicationJob
  queue_as :default

  def perform(appointment)
  	payments = AcuityService.get_payment(appointment.acuity_id)

    payments.each do |payment|
      self.payments.where(payable_id: self.id).first_or_create(
                amount_cents: payment["amount"],
                processor:    payment["processor"],
                external_id:  payment["transactionID"]
                )
    end
  end
end
