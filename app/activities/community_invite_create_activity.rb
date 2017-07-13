class CommunityInviteCreateActivity
  KEY = "community_invite.create"

  def self.get_recipients_for(activity)
    [activity.recipient]
  end

  def self.send_notification(notification)
    NotificationMailer.community_invited(notification).deliver_later
  end
end