class CreatePaymentJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    appointment.update_payments
  end
end
