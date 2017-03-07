class ProjectsController < ApplicationController
  before_action :sign_up_required, except: [:show]
  after_action :verify_authorized, except: [:index]

  before_action :set_user
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    scope = @user.projects.by_position

    if params[:skill]
      scope = scope.with_any_skills(params[:skill])
    end

    @projects = scope
  end

  # GET /projects/1
  def show
    impressionist(@project)
  end

  # GET /projects/new
  def new
    @project = current_user.projects.build
    authorize @project
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = current_user.projects.build(project_params)
    authorize @project
    
    if @project.save
      redirect_to user_project_path(@project.user, @project), notice: 'Project added'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to user_project_path(@project.user, @project), notice: 'Project updated'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    respond_to do |format|
      format.js   { render layout: false }
      format.html { redirect_to current_user, notice: 'Project deleted' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:user_id])
    end

    def set_project
      @project = @user.projects.friendly.find(params[:id])
      authorize @project
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :slug, :position, :image, :retained_image, :remove_image, :image_url, :link, :description, :skills_list, :company_id)
    end
end
