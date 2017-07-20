class AppointmentsController < ApplicationController
  before_action :sign_up_required
  after_action :verify_authorized, except: [:index]

  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :refresh, :complete]

  def index
    @appointments = policy_scope(Appointment).by_start_time
  end

  def show
  end

  def refresh
    if @appointment.refresh
      notice = "Appointment Refreshed"
    end
    redirect_to @appointment, notice: notice
  end

  def complete
    if @appointment.complete!(current_user)
      notice = "Appointment Completed by #{current_user.display_name}"
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
