class ResumesController < ApplicationController
  before_action :sign_up_required
  before_action :set_resume, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index]

  # GET /resumes
  def index
    @resumes = current_user.resumes.by_newest
  end

  # GET /resumes/1
  def show
  end

  # GET /resumes/new
  def new
    @resume = current_user.resumes.build
    authorize @resume
  end

  # POST /resumes
  def create
    @resume = Resume.new(resume_params)
    authorize @resume
    @resume.user = current_user

    if @resume.save
      redirect_to @resume, notice: 'Resume was successfully created.'
    else
      render :new
    end
  end

  # GET /resumes/1/edit
  def edit
  end

  # PATCH/PUT /milestones/1
  def update
    if @resume.update(resume_params)
      redirect_to @resume, notice: 'Resume updated'
    else
      render :edit
    end
  end

  # DELETE /resumes/1
  def destroy
    @resume.destroy
    redirect_to resumes_url, notice: 'Resume was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resume
      @resume = Resume.find(params[:id])
      authorize @resume
    end

    # Only allow a trusted parameter "white list" through.
    def resume_params
      params.require(:resume).permit(:file, :retained_file, :remove_file, :file_url, :private)
    end
end
