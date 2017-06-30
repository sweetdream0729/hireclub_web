class InviteBounceActivity
  KEY = "invite.bounce"
  
  def self.get_recipients_for(activity)
    [activity.recipient]
  end

  def self.send_notification(notification)
    NotificationMailer.invite_bounced(notification).deliver_later
  end
end