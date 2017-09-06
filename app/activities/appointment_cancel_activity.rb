class AppointmentCancelActivity
  KEY = "appointment.cancel"

  def self.get_recipients_for(activity)
    activity.trackable.users
  end

  def self.send_notification(notification)
    NotificationMailer.appointment_canceled(notification).deliver_later
  end
end