class AppointmentMessageCreateActivity
  KEY = "appointment_message.create"

  def self.get_recipients_for(activity)
    appointment_message = activity.trackable
    appointment = appointment_message.appointment

    # Everyone talking in appointment
    recipients = appointment.participants - [appointment_message.user]
    # Including appointment user if user is not one sending message
    recipients << appointment.user if appointment.user != appointment_message.user

    return recipients
  end

  def self.send_notification(notification)
    #return unless notification.user.preference.email_on_comment
    NotificationMailer.appointment_messaged(notification).deliver_later
  end
end
