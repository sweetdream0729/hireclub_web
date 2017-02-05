class MilestonesController < ApplicationController
  before_action :sign_up_required
  after_action :verify_authorized, except: [:index]

  before_action :set_milestone, only: [:show, :edit, :update, :destroy]

  # GET /milestones
  def index
    @milestones = current_user.milestones.by_newest
  end

  # GET /milestones/1
  def show
  end

  # GET /milestones/new
  def new
    @milestone = current_user.milestones.build
    authorize @milestone
  end

  # GET /milestones/1/edit
  def edit
  end

  # POST /milestones
  def create
    @milestone = current_user.milestones.build(milestone_params)
    authorize @milestone

    if @milestone.save
      redirect_to current_user, notice: 'Milestone added'
    else
      render :new
    end
  end

  # PATCH/PUT /milestones/1
  def update
    if @milestone.update(milestone_params)
      redirect_to current_user, notice: 'Milestone updated'
    else
      render :edit
    end
  end

  # DELETE /milestones/1
  def destroy
    @milestone.destroy
    redirect_to current_user, notice: 'Milestone deleted'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_milestone
      @milestone = Milestone.find(params[:id])
      authorize @milestone
    end

    # Only allow a trusted parameter "white list" through.
    def milestone_params
      params.require(:milestone).permit(:title, :start_date, :end_date, :link)
    end
end