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

  def preview
  	@appointment = Appointment.friendly.find(params[:id])
  end
end
