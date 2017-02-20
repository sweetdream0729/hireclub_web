class SkillsController < ApplicationController
  after_action :verify_authorized, except: [:index]
  before_action :set_skill, only: [:show, :edit, :update, :destroy]

  # GET /skills
  def index
    
    if user_signed_in?
      scope = current_user.available_skills.by_name
    else
      scope = Skill.by_name
    end

    if params[:query]
      scope = scope.search_by_name(params[:query])
    end

    @skills = scope.page(params[:page]).per(20)

    respond_to do |format|
      format.json { render json: @skills }
      format.html
    end
  end

  # GET /skills/1
  def show
    @users = @skill.users.page(params[:page])
  end

  # GET /skills/new
  def new
    @skill = Skill.new
    authorize @skill
  end

  # GET /skills/1/edit
  def edit
  end

  # POST /skills
  def create
    @skill = Skill.new(skill_params)
    authorize @skill

    if @skill.save
      redirect_to @skill, notice: 'Skill was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /skills/1
  def update
    if @skill.update(skill_params)
      redirect_to @skill, notice: 'Skill was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /skills/1
  def destroy
    @skill.destroy
    redirect_to skills_url, notice: 'Skill was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.friendly.find(params[:id])
      authorize @skill
    end

    # Only allow a trusted parameter "white list" through.
    def skill_params
      params.require(:skill).permit(:name)
    end
end
