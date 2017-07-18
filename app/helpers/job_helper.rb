module JobHelper
  
  def link_to_refer_job(job, user, options = {})
    options[:class] = "" if options[:class].blank?
    
    if user && job.referred_user(user)
      url = user_url(user)

      options[:class] += " btn btn-sm btn-secondary"
      options[:disabled] = true

      link_to("Referred", url, options)
    else
      url = refer_job_path(job, user_id: user.id)

      options[:method] = :get
      options[:remote] = true if user.present?
      options[:class] += " job_refer_btn_#{user.id} btn btn-primary btn-sm"


      link_to("Refer", url, options)
    end
  end
end