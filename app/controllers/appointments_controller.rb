class AppointmentsController < ApplicationController
  before_action :sign_up_required
  after_action :verify_authorized, except: [:index]

  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :refresh]

  def index
    @appointments = policy_scope(Appointment)
  end

  def show
  end

  def refresh
    if @appointment.refresh
      notice = "Appointment Refreshed"
    end
    redirect_to @appointment, notice: notice
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.friendly.find(params[:id])
      authorize @appointment
    end
end
