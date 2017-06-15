module InviteHelper

  def link_to_invite(invite, options = {})
    url = invite_path(invite)
    options[:method] = :get
    options[:class] = "btn btn-primary"
    link_to("View Invite", url, options)
  end
  
end
