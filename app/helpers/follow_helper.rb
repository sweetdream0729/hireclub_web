module FollowHelper
  
  def link_to_follow_company(company, user, options = {})
    options[:class] = "" if options[:class].blank?

    if user && user.following?(company)
      url = unfollow_company_path(company)

      options[:method] = :get
      options[:remote] = true
      options[:class] += " company_follow_btn_#{company.id} btn btn-secondary"

      link_to("Unfollow", url, options)
    else
      url = follow_company_path(company)

      options[:method] = :get
      options[:remote] = true if user.present?
      options[:class] += " company_follow_btn_#{company.id} btn btn-primary"

      link_to("Follow", url, options)
    end
  end
end