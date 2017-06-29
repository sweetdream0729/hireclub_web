class InviteBounceActivity
  KEY = "invite.bounce"
  
  def self.get_recipients_for(activity)
    [activity.recipient]
  end
end