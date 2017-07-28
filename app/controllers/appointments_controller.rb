class AppointmentsController < ApplicationController
  before_action :sign_up_required
  after_action :verify_authorized, except: [:index, :completed, :canceled, :all, :assigned, :unassigned, :search]

  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :refresh, :complete]

  def index
    @appointments = current_user.appointments.active.incomplete.by_start_time.includes(:appointment_type).page(params[:page])
  end

  def completed
    @appointments = current_user.appointments.completed.by_start_time.includes(:appointment_type).page(params[:page])
    render :index
  end

  def canceled
    @appointments = current_user.appointments.canceled.by_start_time.includes(:appointment_type).page(params[:page])
    render :index
  end

  def assigned
    @appointments = current_user.assigned_appointments.by_start_time.includes(:appointment_type).page(params[:page])
    render :index
  end

  def unassigned
    if !current_user.is_admin
      redirect_to appointments_path 
    else
      @appointments = Appointment.unassigned.by_start_time.includes(:appointment_type).page(params[:page])
      render :index
    end
  end

  def all
    if !current_user.is_admin
      redirect_to appointments_path 
    else
      @appointments = Appointment.by_start_time.includes(:appointment_type).page(params[:page])
      render :index
    end
  end

  def search
    if current_user.has_assignments? || current_user.is_admin
      if current_user.is_admin
        scope = Appointment.text_search(params[:query])
      else
        scope = current_user.assigned_appointments.text_search(params[:query])
      end

      @appointments = scope.page(params[:page])
      render :index
    else
      redirect_to appointments_path 
    end
  end

  def show
    @appointment_user = @appointment.user
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