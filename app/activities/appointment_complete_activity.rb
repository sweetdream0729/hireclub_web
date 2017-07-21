class AppointmentCompleteActivity
  KEY = "appointment.complete"

  def self.get_recipients_for(activity)
    [activity.recipient]
  end

  def self.send_notification(notification)
    #NotificationMailer.appointment_completed(notification).deliver_later
  end
end