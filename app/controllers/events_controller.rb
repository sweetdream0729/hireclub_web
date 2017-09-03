class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :past]

  # GET /events
  def index
    @scope = Event.upcoming.by_start_time
    @events = @scope.page(params[:page]).per(10)
  end

  def past
    @scope = Event.past.by_recent
    @events = @scope.page(params[:page]).per(10)
    render :index
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    authorize @event
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)
    authorize @event

    @event.user = current_user


    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly.find(params[:id])
      authorize @event
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:name, :slug, :start_time, :end_time, :description, :source_url, :venue, :image, :retained_image, :remove_image, :image_url)
    end
end
