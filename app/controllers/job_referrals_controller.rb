class JobReferralsController < ApplicationController
  
  def show
    set_job_referral
    @job_referral.mark_viewed!
    redirect_to @job_referral.job
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_referral
      @job_referral = JobReferral.friendly.find(params[:id])
    end
end