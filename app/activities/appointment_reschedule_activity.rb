class AppointmentRescheduleActivity
  KEY = "appointment.reschedule"

  def self.get_recipients_for(activity)
    recipients = activity.trackable.assigned_users
    recipients << activity.trackable.user
  end

  def self.send_notification(notification)
    NotificationMailer.appointment_rescheduled(notification).deliver_later
  end
end