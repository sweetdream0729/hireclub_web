class MentionCreateActivity
  KEY = "mention.create"

  def self.get_recipients_for(activity)
    [activity.trackable.user] - [activity.trackable.sender]
  end

  def self.send_notification(notification)
    NotificationMailer.comment_mentioned(notification).deliver_later
  end
end