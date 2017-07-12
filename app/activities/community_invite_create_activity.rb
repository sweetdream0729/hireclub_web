class CommunityInviteCreateActivity
  KEY = "community_invite.create"

  def self.get_recipients_for(activity)
    [activity.recipient]
  end
end