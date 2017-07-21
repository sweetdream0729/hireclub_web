class AppointmentReviewsController < ApplicationController
  before_action :set_appointment_review, only: [:show, :edit, :update, :destroy]

  # GET /appointment_reviews
  def index
    @appointment_reviews = AppointmentReview.all
  end

  # GET /appointment_reviews/1
  def show
  end

  # GET /appointment_reviews/new
  def new
    set_appointment
    set_user
    @appointment_review = AppointmentReview.new(appointment: @appointment,user: @user)
  end


  # POST /appointment_reviews
  def create
    @appointment_review = AppointmentReview.new(appointment_review_params)

    if @appointment_review.save
      redirect_to @appointment_review, notice: 'Appointment review was successfully created.'
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

    def set_user
      @user = User.find(params[:user_id])
    end

    # Only allow a trusted parameter "white list" through.
    def appointment_review_params
      params.require(:appointment_review).permit(:appointment_id, :rating, :text, :user_id)
    end
end
