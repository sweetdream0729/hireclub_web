module CommunitiesHelper
    def link_to_join_community(community, user, options = {})
    options[:class] = "" if options[:class].blank?
    
    if user && user.member_of_community?(community)
      url = leave_community_path(community)

      options[:method] = :get
      options[:remote] = true
      options[:class] += " community_join_btn_#{community.id} btn btn-secondary btn-sm"

      link_to("Leave", url, options)
    else
      url = join_community_path(community)

      options[:method] = :get
      options[:remote] = true if user.present?
      options[:class] += " community_join_btn_#{community.id} btn btn-info btn-sm"


      link_to("Join", url, options)
    end
  end
end
