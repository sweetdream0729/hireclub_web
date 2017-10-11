class ProjectSharesController < ApplicationController
  before_action :sign_up_required, except: [:show]
  before_action :set_project_share, only: [:show, :edit, :update, :destroy]

  #after_action :verify_authorized, except: [:index]

  # GET /project_shares
  def index
    @project_shares = current_user.project_shares.by_recent
  end

  # GET /project_shares/1
  def show
    impressionist(@project_share)
    @user = @project_share.user
    @project = @project_share.project
    @project_share.mark_viewed!(current_user)


    if current_user.nil? || (!current_user.is_admin && current_user != @user)
      cookies["viewable_project_#{@project.id}"] = true
    end

    redirect_to project_path(@project_share.project)
  end

  # GET /project_shares/new
  def new
    @project_share = current_user.project_shares.build(project_id: params[:project_id])
    authorize @project_share
  end


  # POST /project_shares
  def create
    @project_share = current_user.project_shares.build(project_share_params)
    authorize @project_share
    if @project_share.save
      ProjectShareMailer.project_shared(@project_share).deliver_later
      redirect_to @project_share, notice: "Project shared with to #{@project_share.input}."
    else
      render :new
    end
  end

  # DELETE /project_shares/1
  def destroy
    @project_share.destroy
    redirect_to project_shares_url, notice: 'ProjectShare was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_share
      @project_share = ProjectShare.friendly.find(params[:id])
      authorize @project_share
    end

    # Only allow a trusted parameter "white list" through.
    def project_share_params
      params.require(:project_share).permit(:input, :text, :project_id)
    end
end
