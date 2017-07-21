class AppointmentReviewsController < ApplicationController
  before_action :sign_up_required
  before_action :set_appointment_review, only: [:show, :edit, :update, :destroy]

  
  # GET /appointment_reviews/1
  def show
    redirect_to @appointment_review.appointment
  end

  # GET /appointment_reviews/new
  def new
    set_appointment
    @appointment_review = AppointmentReview.new(appointment: @appointment)
  end


  # POST /appointment_reviews
  def create
    @appointment_review = AppointmentReview.new(appointment_review_params)
    @appointment_review.user = current_user

    if @appointment_review.save
      redirect_to @appointment_review.appointment, notice: 'Thanks for your review!'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment_review
      @appointment_review = AppointmentReview.find(params[:id])
    end

    def set_appointment
      @appointment = Appointment.find(params[:appointment_id])
    end

    # Only allow a trusted parameter "white list" through.
    def appointment_review_params
      params.require(:appointment_review).permit(:appointment_id, :rating, :text)
    end
end
