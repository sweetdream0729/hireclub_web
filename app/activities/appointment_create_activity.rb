class AppointmentCreateActivity
  KEY = "appointment.create"

  def self.get_recipients_for(activity)
    appointment = activity.trackable
    User.admin + appointment.users
  end

  # def self.send_notification(notification)
  #   NotificationMailer.appointment_completed(notification).deliver_later
  # end
end