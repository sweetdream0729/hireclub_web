class AppointmentCancelActivity
  KEY = "appointment.cancel"

  def self.get_recipients_for(activity)
    recipients = activity.trackable.assigned_users.to_ary
    recipients << activity.trackable.user
  end

  def self.send_notification(notification)
    NotificationMailer.appointment_canceled(notification).deliver_later
  end
end