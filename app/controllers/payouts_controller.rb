class PayoutsController < ApplicationController

  def create
  	@appointment = Appointment.find(params[:appointment_id])
  	@payout = @appointment.payout!
  	if @payout.present?
  		redirect_to @appointment, notice: "Transfer successful"
    else
      redirect_to @appointment, alert: "Transfer failed"
    end
  end

  def new
  	@appointment = Appointment.friendly.find(params[:appointment_id])
    if @appointment.payee.nil?
      redirect_to @appointment, alert: "No payee set!"
    elsif @appointment.payee.provider.nil?
      redirect_to @appointment, alert: "Payee should be registered as provider to receive funds!"
    elsif !@appointment.completed?
      redirect_to @appointment, alert: "Appointment not completed yet!"
    end

    @provider = @appointment.payee.try(:provider)
  end
end
