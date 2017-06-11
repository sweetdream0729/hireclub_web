class MessageUnreadActivity
  KEY = "message.unread"

  def self.get_recipients_for(activity)
    [activity.owner]
  end

  def self.send_notification(notification)
    self.send_push(notification)
  end

  def self.send_push(notification)
    return unless notification.present?
    message = notification.activity.trackable

    link = Rails.application.routes.url_helpers.conversation_url(message.conversation, host: Rails.application.secrets.domain_name)

    OnesignalService.send(  notification,
                            message.text.truncate(25),
                            link,
                            nil)
  end
end
