class PayoutCreateActivity
  KEY = "payout.create"

  def self.get_recipients_for(activity)
    payout = activity.trackable
    User.admin + [payout.provider.try(:user)]
  end

  # def self.send_notification(notification)
  #   NotificationMailer.appointment_completed(notification).deliver_later
  # end
end