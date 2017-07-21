class AppointmentReviewCreateActivity
  KEY = "appointment_review.create"

  def self.get_recipients_for(activity)
    appointment_review = activity.trackable
    appointment = appointment_review.appointment

    # all user assigned to appointment
    recipient_ids = appointment.assignees.pluck(:user_id)
   
    recipients = User.where(id: recipient_ids)
  
  end

  def self.send_notification(notification)
    #return unless notification.user.preference.email_on_comment
    NotificationMailer.appointment_reviewed(notification).deliver_later
  end
end
