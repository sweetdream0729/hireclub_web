class InviteFirstViewActivity
  KEY = "invite.first_view"
  def self.get_recipients_for(activity)
    [activity.recipient]
  end
end
