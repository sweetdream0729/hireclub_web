class ProviderCreateActivity
  KEY = "provider.create"

  def self.get_recipients_for(activity)
    User.admin
  end

  def self.send_notification(notification)
    NotificationMailer.provider_created(notification).deliver_later
  end
end