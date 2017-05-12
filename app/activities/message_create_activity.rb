class MessageCreateActivity
  KEY = "message.create"

  def self.get_recipients_for(activity)
    message = activity.trackable
    recepients = message.conversation.users - [message.user]
  end

  def self.send_notification(notification)
    #NotificationMailer.delay.user_followed(notification)
    self.send_push(notification)
  end

  def self.send_push(notification)
    return unless notification.present?
    message = notification.activity.trackable

    title = "#{message.user.short_display_name}: #{message.text.truncate(25)}"
    link = Rails.application.routes.url_helpers.conversation_url(message.conversation, host: Rails.application.secrets.domain_name)

    OnesignalService.send(  notification, 
                            title,
                            link,
                            nil)
  end
end