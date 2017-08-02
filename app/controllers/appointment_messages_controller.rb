class AppointmentMessagesController < ApplicationController
  after_action :verify_authorized, except: [:index]
  before_action :set_appointment_message, only: [:edit, :update, :cancel_edit, :destroy]

  def create
    @appointment = Appointment.find(appointment_message_params[:appointment_id])
    @appointment_message = @appointment.appointment_messages.new appointment_message_params
    authorize @appointment_message
    @appointment_message.user = current_user
    
    if @appointment_message.save 
      redirect_to @appointment, notice: "Message sent."
    else
      redirect_to @appointment
    end
  end

  def edit
  end

  def update
    @appointment = @appointment_message.appointment
    @appointment_message.text = appointment_message_params[:text]
    authorize @appointment_message
    @appointment_message.save 
    #   redirect_to @appointment, notice: "Message updated"
    # else
    #   redirect_to @appointment, notice: "Message not updated"
    # end
  end

  def cancel_edit
  end

  def destroy
    @appointment_message.destroy
    redirect_to @appointment_message.appointment, alert: "Message deleted."
  end

  private
    def set_appointment_message
      @appointment_message = AppointmentMessage.find(params[:id])
      authorize @appointment_message
    end

    def appointment_message_params
      params.require(:appointment_message).permit(:text, :appointment_id)
    end
end
