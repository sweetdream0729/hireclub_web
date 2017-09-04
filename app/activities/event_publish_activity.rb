class EventPublishActivity
  KEY = "event.publish"

  def self.get_recipients_for(activity)
    # Event User followers
    recepients = activity.trackable.user.followers + User.admin - [activity.trackable.user]
  end

  def self.send_notification(notification)
    return unless notification.user.preference.email_on_event_publish
    NotificationMailer.event_published(notification).deliver_later
  end

end