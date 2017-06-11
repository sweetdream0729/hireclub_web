class UserWelcomeActivity
  KEY = "user.welcome"

  def self.get_recipients_for(activity)
    recepients = [activity.owner]
  end

  def self.send_notification(notification)
    NotificationMailer.user_welcome(notification).deliver_later
  end
end