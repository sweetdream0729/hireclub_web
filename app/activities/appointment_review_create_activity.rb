class AppointmentReviewCreateActivity
  KEY = "appointment_review.create"

  def self.get_recipients_for(activity)
    appointment_review = activity.trackable
    appointment = appointment_review.appointment   
    recipients = appointment.assigned_users
  end

  def self.send_notification(notification)
    NotificationMailer.appointment_reviewed(notification).deliver_later
  end
end
