class AppointmentCancelActivity
  KEY = "appointment.cancel"

  def self.get_recipients_for(activity)
    recipients = activity.trackable.assigned_users.to_ary
    puts "\n\n\n #{recipients} \n\n\n"
    recipients << activity.trackable.user
    puts "\n\n\n #{recipients} \n\n\n"
    return recipients
  end

  def self.send_notification(notification)
    NotificationMailer.appointment_canceled(notification).deliver_later
  end
end