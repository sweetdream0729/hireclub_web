class UserFollowActivity
  KEY = "user.follow"

  def self.get_recipients_for(activity)
    recepients = [activity.trackable]
  end

  def self.send_notification(notification)
    NotificationMailer.delay.user_followed(notification)
  end
end