class ProjectsController < ApplicationController
  before_action :sign_up_required, except: [:show, :index]
  after_action :verify_authorized, except: [:index, :show]

  before_action :set_project, only: [:show, :edit, :update, :destroy]
  
  # GET /projects
  def index
    scope = Project.with_image
    @title = "Projects"

    if params[:sort_by] == "popular"
      scope = scope.by_likes
    elsif params[:sort_by] == "oldest"
      scope = scope.by_oldest
    else
      scope = scope.by_recent
    end

    if params[:username]
      @user = User.friendly.find(params[:username])
      scope = scope.viewable_by(current_user, @user)

      @title = "#{@title} by #{@user.display_name}"
    end

    if params[:skill]
      scope = scope.with_any_skills(params[:skill])
      @title = "#{params[:skill]} #{@title}"
    end

    @count = scope.count
    @projects = scope.page(params[:page]).per(12).includes(:user)
  end

  # GET /projects/1
  def show
    if @project.private && !user_signed_in? && cookies["viewable_project_#{@project.id}"].blank?
      user_not_authorized
    end

    impressionist(@project)
  end

  # GET /projects/new
  def new
    @project = current_user.projects.build
    authorize_project
  end

  # GET /projects/1/edit
  def edit
    authorize_project
  end

  # POST /projects
  def create
    @project = current_user.projects.build(project_params)
    authorize_project
    
    if @project.save
      redirect_to project_path(@project), notice: 'Project added'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    authorize_project
    if @project.update(project_params)
      @project.reload
      redirect_to project_path(@project), notice: 'Project updated'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    authorize_project
    @project.destroy
    respond_to do |format|
      format.js   { render layout: false }
      format.html { redirect_to current_user, notice: 'Project deleted' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])
    end

    def authorize_project
      authorize @project
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :slug, :position, :image_uid, :image, :retained_image, :remove_image, :image_url, :link, :description, :skills_list, :company_id, :completed_on, :completed_on_formatted, :private)
    end
end
