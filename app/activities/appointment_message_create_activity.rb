class AppointmentMessageCreateActivity
  KEY = "appointment_message.create"

  def self.get_recipients_for(activity)
    appointment_message = activity.trackable
    appointment = appointment_message.appointment

    # Everyone talking in appointment
    recipients = User.admin + appointment.users - [appointment_message.user]
    return recipients
  end

  def self.send_notification(notification)
    #return unless notification.user.preference.email_on_comment
    NotificationMailer.appointment_messaged(notification).deliver_later
  end
end
