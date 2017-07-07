class ConversationUserUnreadActivity
  KEY = "conversation_user.unread"

  def self.get_recipients_for(activity)
    [activity.owner]
  end

  def self.send_notification(notification)
    return unless notification.user.preference.email_on_unread
    NotificationMailer.conversation_unread(notification).deliver_later
  end
end
