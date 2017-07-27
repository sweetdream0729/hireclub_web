class Appointments::AttachmentsController < AttachmentsController
  before_action :set_attachable

  private
    def set_attachable
      @attachable = Appointment.friendly.find(params[:appointment_id])
    end
end