class PayoutsController < ApplicationController

  def create
  	@appointment = Appointment.find(params[:appointment_id])
  	@payout = @appointment.payout!
  	if @payout.present?
  		redirect_to @appointment, notice: "Transfer successful"
    else
      redirect_to @appointment, notice: "Transfer failed"
    end
  end

  def new
  	@appointment = Appointment.friendly.find(params[:id])
    @provider = @appointment.payee.provider
    if @provider.nil?
      redirect_to @appointment, notice: "Payee should be registered as provider to receive funds"
    end
  end
end
