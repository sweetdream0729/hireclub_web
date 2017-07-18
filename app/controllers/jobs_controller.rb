class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :suggest_skill, :refer]
  after_action :verify_authorized, except: [:index]

  # GET /jobs
  def index
    scope = Job.recent
    @jobs = scope.page(params[:page]).per(10).includes(:company, :user, :location, :role)
  end

  # GET /jobs/1
  def show
    impressionist(@job)
    @company = @job.company

    if current_user
      @job_score = @job.job_scores.where(user: current_user).first_or_create
      @job_score.update_score
    end
  end

  def suggest_skill
    notice = nil
    if params[:skill].present?
      skill = Skill.search_by_exact_name(params[:skill]).first
      if skill.present? && @job.add_skill!(skill.name)
        @job.update_suggested_skills!
        notice = "Added #{skill.name} to job"
      end
    end

    redirect_to @job, notice: notice
  end

  # GET /jobs/new
  def new
    @job = Job.new
    authorize @job
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  def create
    @job = current_user.jobs.build(job_params)

    authorize @job

    if @job.save
      @job.publish!
      @job.update_suggested_skills!
      UpdateJobScoresJob.perform_later(@job)
      redirect_to @job, notice: 'Job was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /jobs/1
  def update
    if @job.update(job_params)
      @job.update_suggested_skills!
      UpdateJobScoresJob.perform_later(@job)
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render :edit
    end
  end

  def refer
    @user = User.find(params[:user])
    sender = User.find_by_username('kidbombay')
    
    JobReferral.refer_user(sender, @user, @job) if sender

    respond_to do |format|
      format.js { render :refer}
      format.html { redirect_to @job }
    end
  end

  # DELETE /jobs/1
  def destroy
    @job.destroy
    redirect_to jobs_url, notice: 'Job was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.friendly.find(params[:id])
      authorize @job
    end

    # Only allow a trusted parameter "white list" through.
    def job_params
      params.require(:job).permit(:name, :slug, :company_id, :location_id, :role_id, :skills_list,
        :description, :link,
        :full_time,
        :part_time,
        :remote,
        :contract,
        :internship)
    end
end
