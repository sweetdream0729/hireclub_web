class AppointmentRescheduleActivity
  KEY = "appointment.reschedule"

  def self.get_recipients_for(activity)
    activity.trackable.users
  end

  def self.send_notification(notification)
    NotificationMailer.appointment_rescheduled(notification).deliver_later
  end
end